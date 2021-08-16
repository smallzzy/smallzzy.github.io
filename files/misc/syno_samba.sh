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
# # /volume1/@appdata/DirectoryServerForWindowsDomain/samba/usr/share/samba/setup/ypServ30.ldif


## this following path is generated
# /etc/samba/synoadserver.conf
## edit this instead
# /var/packages/DirectoryServerForWindowsDomain/conf/etc/smb.option.conf.mustache
idmap_ldb:use rfc2307 = true

## remote manage via samba-tool
# use ldaps when possible
samba-tool <cmd> -H ldap://ad.kneron.com -UAdministrator

## file access control
## do not allow delete on synology
# synoacltool 

## sticky bit on linux
