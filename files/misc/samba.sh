# check samba version vs bind 9 support
# https://wiki.samba.org/index.php/BIND9_DLZ_DNS_Back_End#Configuring_the_BIND9_DLZ_Module
# they do not match for ubuntu 20.04
# currently, we deploy on 21.04 instead

# setup samba 
## https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller
# 1. hostname
# 2. domain name 
hostnamectl set-hostname dc1.samdom.example.com
# 3. static ip -> guarantee by dhcp
# 4. host resolve to lan ip only
## edit /etc/hosts
## <lan ip> dc1.samdom.example.com dc1
# reboot!!

# install package 
## bind
## https://wiki.samba.org/index.php/Setting_up_a_BIND_DNS_Server#Installing_BIND
## do not config bind just yet
apt-get install -y bind9 bind9utils
## samba
apt-get install acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user dnsutils
# it will ask three questions about default realm, kdc server, admin_server 
# it does not matter because krb.conf will be override later
# client maybe install? libpam-winbind libnss-winbind libpam-krb5 

# 4. disable resolv.conf from being updated automatically
# in this case, we change it to local bind server
## dig A facebook.com @127.0.0.1
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

## provision samba ad
sudo samba-tool domain provision --use-rfc2307 --interactive

## https://wiki.samba.org/index.php/BIND9_DLZ_DNS_Back_End#Configuring_the_BIND9_DLZ_Module
## has listed what to change in each section. But the path is corrent in the following link
## https://wiki.samba.org/index.php/Setting_up_a_BIND_DNS_Server#Installing_.26_Configuring_BIND_on_Debian_based_distros

# named.conf.local
## include "/var/lib/samba/bind-dns/named.conf";

# named.conf.options
## tkey-gssapi-keytab "/var/lib/samba/bind-dns/dns.keytab";
## minimal-responses yes;

# /etc/resolv.conf
search samdom.example.com
nameserver <lan ip>

# https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller
sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

sudo systemctl enable samba-ad-dc.service

# https://wiki.samba.org/index.php/Configuring_LDAP_over_SSL_(LDAPS)_on_a_Samba_AD_DC
