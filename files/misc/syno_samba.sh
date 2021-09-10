## install dsm 
# machine name dc1
## secure advisor
## scrub
## smart
## empty trash can

## directory server
# static ip
# enable ssh during setup only?

# synopkg start/stop DirectoryServerForWindowsDomain

# import rfc2307 schema
# /var/packages/SMBService/target/usr/bin/ldbmodify
# /volume1/@appdata/DirectoryServerForWindowsDomain/private/sam.ldb
# /volume1/@appdata/DirectoryServerForWindowsDomain/samba/usr/share/samba/setup/ypServ30.ldif
sed -i -e 's/${DOMAINDN}/DC=samdom,DC=example,DC=com/g' \
       -e 's/${NETBIOSNAME}/DC1/g' \
       -e 's/${NISDOMAIN}/samdom/g' \
       /tmp/ypServ30.ldif

<ldbmodify> -H <sam.ldb> /tmp/ypServ30.ldif --option="dsdb:schema update allowed"=true

## also import sudo schema here
schema.ActiveDirectory
role.ActiveDirectory

## the dc is run with the follow config file, but this file is generated
# /etc/samba/synoadserver.conf
## edit this instead
# /var/packages/DirectoryServerForWindowsDomain/conf/etc/smb.option.conf.mustache
idmap_ldb:use rfc2307 = true

## setup tls on synology
# 1. sign both dc and ad together
# 2. immediate crt is needed if multiple agents are involved
#    it is not required
## check this file to see if tls is enabled
# /var/packages/DirectoryServerForWindowsDomain/conf/etc/smb.tls.conf.mustache
ldapadd -H ldaps://ad.kneron.com -D "ad\Administrator" -W -f sudoers_ou.ldif
# ldapadd -H ldap://ad.kneron.com -D "ad\Administrator" -W -f sudoers_ou.ldif -ZZ

## remote manage via samba-tool
# use ldaps when possible
samba-tool <cmd> -H ldaps://samdom.example.com -UAdministrator

## create new user 
samba-tool user create test

## because we specify rfc2307 + no auto mapping,
## we need to add attr to user / group before they can be accessed on unix

# in newer version samba-tool, available on ubuntu 21.04
# there is addunixattrs

## first, assign a base group to every user (only required once)
samba-tool group addunixattrs 'Domain Users' 10000

## then, assign attr to user
samba-tool user addunixattrs test
# --gid-number defaults to value as Domain Users
# --unix-home defaults to /home/DOMAIN/username
# --login-shell defaults to /bin/sh

# on older samba-tool, you can need to add attribute manually
samba-tool user edit
# you need to edit the following attribute
# for group
gidNumber: 10000

# for user
uidNumber: 10000
gidNumber: 10000
loginShell: /bin/bash
unixHomeDirectory: /home/user_name
# gecos:
# uid:

# not necessary?
# msSFU30NisDomain:

## file access control
## do not allow delete on synology
# synoacltool 

## sticky bit on linux
