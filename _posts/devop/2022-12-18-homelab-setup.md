---
layout: post
title:
date: 2022-12-18 19:21
category:
author:
tags: []
summary:
---

## router config

1. initially setup the dhcp server
2. config router ip to 192.168.50.1/24

## synology config

1. reserve one ethernet port for dhcp config
2. config static ip as 192.168.50.2/24, gateway to router
3. install directory server & dhcp server
   1. more detail can be found in syno_samba.sh
4. enable dhcp server
   1. turn off router dhcp config

## truenas config

Enable Host Path Safety Checks

## supermicro config

https://forums.servethehome.com/index.php?resources/supermicro-x9-x10-x11-fan-speed-control.20/
note that bmc fan config only kicks in when system is fully booted




A really dumb of setting up http to https redirect on synology server

1. `http://git.zeltar.info:80` -> reverse proxy -> localhost:10080
2. `localhost:10080` -> web station -> return a page which modify the http to https
3. `https://git.zeltar.info:443` -> reverse proxy -> localhost:443.
   1. synology will apply https certificate as the proxy

## smb share / unix permission

unix permission is only allowed with smb 1 and smb 3.11

smb1 is too weak to be used
smb3.11 cannot be used due to lack of support on truenas??

as a result, smb share only shows a dummy permission based uid / gid
it does not work well with docker if a container decide to change the option

## nfs

by default nfs is not encrypted.
kerberos server is a valid option but require too much setup.

for now, only share download server which is not important as nfs




## rootless podman

rootless podman require the following two files to be setup

https://github.com/containers/podman/issues/1182#issuecomment-574888124

/etc/subuid
/etc/subgid

or it can be done with command line as well.

sudo usermod --add-subuids 10000-75535 USERNAME
sudo usermod --add-subgids 10000-75535 USERNAME

note that subgid matches against username instead of group name

rm -rf ~/.{config,local/share}/containers /run/user/$(id -u)/{libpod,runc,vfs-*}

### the issue

https://www.redhat.com/sysadmin/user-flag-rootless-containers

rootless podman ->
0 is mapped to uid
other uid mapped based on offset provided in subuid / subgid

1. `--user`: start execution with certain uid instead of 0, the offset is still applied
2. `--userns keep-id`: execute the container with same uid as the user

note that docker image assume root when starting and optionally transition into another user before running anything
this assumption is broken with both option above.

### the WAR

```bash
# pretend to run as root. and keep it that way
podman run -d \
   --name qbittorrent-nox \
   -e QBT_EULA=accept \
   -e QBT_WEBUI_PORT=20909 \
   -e TZ=America/Los_Angeles \
   -e PUID=0 \
   -e PGID=0 \
   -p 20909:20909/tcp \
   -p 6881:6881/tcp \
   -p 6881:6881/udp \
   -v /mnt/download/qbt_config:/config \
   -v /mnt/download/qbt_downloads/:/downloads \
   qbittorrentofficial/qbittorrent-nox:latest

# generate podman service to be run at first login
podman generate systemd --name qbittorrent-nox > ~/.config/systemd/user/qbt.service
systemctl enable --user qbt.service

# allow service to start on boot
loginctl enable-linger username
```
