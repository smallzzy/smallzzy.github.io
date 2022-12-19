---
layout: post
title:
date: 2022-12-18 19:21
category:
author:
tags: []
summary:
---

A really dumb of setting up http to https redirect on synology server

1. `http://git.zeltar.info:80` -> reverse proxy -> localhost:10080
2. `localhost:10080` -> web station -> return a page which modify the http to https
3. `https://git.zeltar.info:443` -> reverse proxy -> localhost:443.
   1. synology will apply https certificate as the proxy
