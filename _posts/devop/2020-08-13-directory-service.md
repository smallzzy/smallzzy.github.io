---
layout: post
title:
date: 2020-08-13 17:22
category:
author:
tags: [misc]
summary:
---

## what is a directory service

A directory service provides a structuralized database.
Which is usually used to organize people, group, etc.

Many vendors provide softwares that implement directory service.
Such as Microsoft Active Directory, OpenLDAP.

For other softwares that wants to communicate to a directory service.
They talks in a protocol called LDAP.

## what does a directory service provide

Copied from [ubuntu documentation](https://ubuntu.com/server/docs/service-ldap). Highlight on keywords.

- A directory is a tree of data `entries` that is hierarchical in nature and is called the `Directory Information Tree (DIT)`.
- An entry consists of a set of `attributes`.
- An attribute has a key (a name/description) and one or more values.
- Every attribute must be defined in at least one `objectClass`.
- Attributes and objectClasses are defined in schemas (an objectClass is actually considered as a special kind of attribute).
- Each entry has a unique identifier: its `Distinguished Name (DN or dn)`. This, in turn, consists of a `Relative Distinguished Name (RDN)` followed by the parent entry’s DN.
- The entry’s DN is not an attribute. It is not considered part of the entry itself.

### LDIF: LDAP Data Interchange Protocol

- dn: distinguished name
  - uniquely identify each enry
  - read from right to left
  - consist of cn, ou, dc
- dc: domain component
- ou: organizational unit
- cn: common name

## Microsoft Active Directory

- Microsoft AD is a bundle of different service
  - AD Domian Service: directory service
  - AD LDS: implements LDAP protocol
- There used to be a domain service called NT4?
  - probably in the 2000?

## OpenLDAP

```
apt install slapd ldap-utils
dkpg-reconfigure slapd
```

- [layout](https://www.openldap.org/doc/admin24/slapdconf2.html#Configuration%20Layout)
  - The slapd configuration is stored as a special LDAP directory with a predefined schema and DIT
- Data is stored in several `olcDatabase`s
  - `{-1}frontend`: store default configs for all db
  - `{0}config`: slapd config db
    - known as `cn=config`
  - `{1}mdb`: user db
- During configuration, we setup the user db
  - the provided domain name becomes base dn
    - `example.com` -> `dc=example,dc=com`
  - the provided passwd becomes `olcRootPW`
    - `olcRootDN` is `cn=admin,dc=exmample,dc=com`
- `olcAccess` controls how users can access one db
  - `olcRootDN` always has full access to that db
  - `cn=config` is limited to local root by default

### change olcRootPW

```
# generate hashed passwd
slappasswd

# root_pw.ldif
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: {SSHA}cZbRoOhRew8MBiWGSEOiFX0XqbAQwXUr
```

## ldap-tools

In order to form a ldap connection, you need the following:

1. `-H` URI
   1. `ldap://` network
      1. `-ZZ`: force ssl
   2. `ldapi:///` local unix socket
2. `-D`: bind DN. ie user account
   1. `user@samdom.example.com` for ad
   2. otherwise, dn = anonymous
3. authorization:
   1. `-x`: plain text auth
   2. `-Y`: SASL method
   3. `-Y EXTERNAL`: only works for `ldapi`
   4. `-W`: interactive password
4. `-b`: search base. ie where to look for object

- `-LLL`: reduce display data
- common command: `ldapsearch`, `ldapwhoami`, `ldapadd`, `ldapmodify`

- `man 5 ldap.conf`
  - the default should be `/etc/ldap/ldap.conf`
  - but other package might defined addtional files
  - pam -> `/etc/ldap.conf`
  - sudo -> `/etc/sudo-ldap.conf`

[ldapscripts](https://ubuntu.com/server/docs/service-ldap-usage)

## ldap tls

- openldap's cert is set in its own conf instead of ca-certificate
- need to deploy root certificate to server
- check ssl connection `openssl s_client -connect domain:port -showcerts`
  - `--starttls ldap` force tls connection
- server can force tls connection `olcSecurity: tls=1`
  - breaks `ldapi:///` -> do not force tls

## ldap pam

- several methods exist for authentication
  - based on direct ldap: libnss-ldap + libpam-ldap
  - based on nslcd: libnss-ldapd + libpam-ldapd
  - based on sssd
- sssd seems to be the most integrated solution

## todo

https://www.flomain.de/2018/09/using-linux-with-openldap-for-user-dhcp-and-dns/

https://serverfault.com/questions/617678/cant-use-external-authentication-after-enabling-tls-in-ldap-2-4

include SUDO schema

https://kifarunix.com/install-and-setup-openldap-server-on-ubuntu-20-04/

## Samba AD

follow the samba.sh to bring up samba ad service

## sssd

- generate log put `debug_log` at each section in sssd
- sssd provides the following capability
  - id: user information (based on sssd-ldap)
  - auth: user authentication (based on sssd-krb5)
  - access?
  - chpass?
  - sudo?
  - autofs?
