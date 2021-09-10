# check samba version vs bind 9 support
# https://wiki.samba.org/index.php/BIND9_DLZ_DNS_Back_End#Configuring_the_BIND9_DLZ_Module
# they do not match for ubuntu 20.04
# currently, we deploy on 21.04 instead

# 1. prepare samba for dc
## https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller
# make sure time sync
sudo timedatectl set-timezone
# hostname & domain name 
sudo hostnamectl set-hostname dc1.samdom.example.com
# edit /etc/hosts
## for server, host should only resolve to lan ip (requires static ip)
## for client, host can resolve to loopback
## <lan ip> dc1.samdom.example.com dc1
# reboot!!

# install package 
## bind
## https://wiki.samba.org/index.php/Setting_up_a_BIND_DNS_Server#Installing_BIND
## do not config bind just yet
sudo apt-get install -y bind9 bind9utils
## samba
sudo apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user dnsutils
# it will ask three questions about default realm, kdc server, admin_server 
# it does not matter because krb.conf will be override later

# disable resolv.conf from being updated automatically
# in this case, we change it to local bind server
## `/etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf`
sudo systemctl mask systemd-resolved
sudo rm /etc/resolv.conf

# vim /etc/resolv.conf
## to verify bind is working `dig A facebook.com @127.0.0.1`
## search domain is used to create FQDN from relative name
# search samdom.example.com
# nameserver <lan ip>

# disable sambda relate process
sudo systemctl stop samba-ad-dc.service smbd.service nmbd.service winbind.service
sudo systemctl disable samba-ad-dc.service smbd.service nmbd.service winbind.service

# remove existing config and database
smbd -b | grep "CONFIGFILE" | awk '{print $2}' | xargs -I % sudo mv % %.old
smbd -b | egrep "LOCKDIR|STATEDIR|CACHEDIR|PRIVATE_DIR"  | awk '{print $2}' | xargs -I % sudo find % \( -name "*.tdb" -o -name "*.ldb" \) -exec mv {} {}.old \;
sudo mv /etc/krb5.conf /etc/krb5.conf.old

# 2. provision samba ad (primary)
## https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller
sudo samba-tool domain provision --use-rfc2307 --interactive

# config bind service
## use the following link to find out what to change in each section.
## https://wiki.samba.org/index.php/BIND9_DLZ_DNS_Back_End#Configuring_the_BIND9_DLZ_Module
## but the following link contains a more correct file path
## https://wiki.samba.org/index.php/Setting_up_a_BIND_DNS_Server#Installing_.26_Configuring_BIND_on_Debian_based_distros

# named.conf.local
## as a sancheck, cat this file & check version
include "/var/lib/samba/bind-dns/named.conf";

# named.conf.options
tkey-gssapi-keytab "/var/lib/samba/bind-dns/dns.keytab";
minimal-responses yes;

# check config & restart bind
sudo named-checkconf
sudo systemctl restart bind9

# new krb config
sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

sudo systemctl unmask samba-ad-dc.service
sudo systemctl enable --now samba-ad-dc.service

# prepare osync
## https://wiki.samba.org/index.php/Bidirectional_Rsync/osync_based_SysVol_replication_workaround

# 2.1 provision samba ad (secondary)
## https://wiki.samba.org/index.php/Joining_a_Samba_DC_to_an_Existing_Active_Directory

# new krb config
[libdefaults]
    dns_lookup_realm = false
    dns_lookup_kdc = true
    default_realm = SAMDOM.EXAMPLE.COM

# join domain
samba-tool domain join samdom.example.com DC -U"SAMDOM\administrator" \
    --dns-backend=BIND9_DLZ \
    --option='idmap_ldb:use rfc2307 = yes'

# config bind (same as above)

# prepare osync

# start bind
## check status, there might be permission problems
sudo systemctl restart bind9

## 2.2 various setting and tests
# ldap tls is necessary?
# https://wiki.samba.org/index.php/Configuring_LDAP_over_SSL_(LDAPS)_on_a_Samba_AD_DC

# a reserve zone is necessary for ddns to setup PTR
## and other domain might be wanted
## https://wiki.samba.org/index.php/DNS_Administration
samba-tool dns zonecreate samdom.example.com 168.192.in-addr.arpa -UAdministrator

# check for dns
## note: ipv6 might have different dns
host -t SRV _ldap._tcp.samdom.example.com.

## nslookup for windows
## set q=srv
## _ldap._tcp.dc._msdcs.samdom.example.com

# make sure dynamic dns update can succeed locally
## relate to bind tkey settings or needs to start bind
sudo samba_dnsupdate --verbose --all-names

# check if Kerberos can succeess
## the realm has to be uppercase
KRB5_TRACE=/dev/stdout kinit Administrator@SAMDOM.EXAMPLE.COM

# 3. linux join domain
## timezone, hostname, (dns)
## avoid sssd generate mapping for uid
sudo realm join --user=Administrator --automatic-id-mapping=no samdom.example.com

## check user id
id administrator@samdom.example.com

## samba unable to login
## https://serverfault.com/questions/872542/debugging-sssd-login-pam-sss-system-error
ad_gpo_access_control = permissive
## login without using domain
## https://serverfault.com/questions/679236/configure-realmd-to-allow-login-without-domain-name
use_fully_qualified_names = False

## todo: sudo account?

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859445
https://dev.tranquil.it/samba/en/index.html
