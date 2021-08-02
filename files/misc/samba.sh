# check samba version vs bind 9 support
# https://wiki.samba.org/index.php/BIND9_DLZ_DNS_Back_End#Configuring_the_BIND9_DLZ_Module
# they do not match for ubuntu 20.04
# currently, we deploy on 21.04 instead

# setup samba 
## https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller
# make sure time sync
timedatectl set-timezone
# hostname & domain name 
hostnamectl set-hostname dc1.samdom.example.com
# host should only resolve to lan ip (requires static ip)
## edit /etc/hosts
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

# 4. disable resolv.conf from being updated automatically
# in this case, we change it to local bind server
## `/etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf`
sudo systemctl mask systemd-resolved
rm /etc/resolv.conf

# 5. disable sambda relate process
sudo systemctl stop samba-ad-dc.service smbd.service nmbd.service winbind.service
sudo systemctl disable samba-ad-dc.service smbd.service nmbd.service winbind.service

# 6. remove existing config and database
smbd -b | grep "CONFIGFILE" | awk '{print $2}' | xargs -I % sudo mv % %.old
smbd -b | egrep "LOCKDIR|STATEDIR|CACHEDIR|PRIVATE_DIR"  | awk '{print $2}' | xargs -I % sudo find % \( -name "*.tdb" -o -name "*.ldb" \) -exec mv {} {}.old \;
sudo mv /etc/krb5.conf /etc/krb5.conf.old

# 7. provision samba ad
## https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller
sudo samba-tool domain provision --use-rfc2307 --interactive

# 8. config bind service
## use the following link to find out what to change in each section.
## https://wiki.samba.org/index.php/BIND9_DLZ_DNS_Back_End#Configuring_the_BIND9_DLZ_Module
## but the following link contains a more correct file path
## https://wiki.samba.org/index.php/Setting_up_a_BIND_DNS_Server#Installing_.26_Configuring_BIND_on_Debian_based_distros

# named.conf.local
## include "/var/lib/samba/bind-dns/named.conf";

# named.conf.options
## tkey-gssapi-keytab "/var/lib/samba/bind-dns/dns.keytab";
## minimal-responses yes;

# check config & restart bind
named-checkconf
sudo systemctl restart bind9

# /etc/resolv.conf
## to verify bind is working `dig A facebook.com @127.0.0.1`
## search domain is used to create FQDN from relative name
search samdom.example.com
nameserver <lan ip>

sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

# sudo systemctl unmask samba-ad-dc.service
sudo systemctl enable --now samba-ad-dc.service

# ldap tls is necessary?
# https://wiki.samba.org/index.php/Configuring_LDAP_over_SSL_(LDAPS)_on_a_Samba_AD_DC

## check ns from windows
## nslookup
## set q=srv
## _ldap._tcp.dc._msdcs.samdom.example.com

## note: ipv6 might have different dns

# linux join domain
## timezone, hostname, (dns)
## avoid sssd generate mapping for uid
sudo realm join --user=Administrator --automatic-id-mapping=no samdom.example.com

# check for id
## todo: find out current uid to set?
## todo: gid needed?
# sudo samba-tool user create test
sudo samba-tool user addunixattrs administrator 10000 --gid-number=10000
id administrator@samdom.example.com

# make sure dynamic dns update can succeed locally
sudo samba_dnsupdate --verbose --all-names

# a reserve zone seems to be necessary for dynamic dns to success completely
## and other domain might be wanted
## https://wiki.samba.org/index.php/DNS_Administration
samba-tool dns zonecreate samdom.example.com 168.192.in-addr.arpa -uAdministrator
rndc flush && rndc reload

# login without using domain
## https://serverfault.com/questions/679236/configure-realmd-to-allow-login-without-domain-name
## client sssd.conf: use_fully_qualified_names = False

## todo: cannot login?
## todo: sudo account?
