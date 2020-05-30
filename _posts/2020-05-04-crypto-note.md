---
layout: post
title: 
date: 2020-05-04 16:00
category: 
author: 
tags: [pwn]
summary: 
---

## crypto

* encrypt-then-MAC
* forward secrecy

[freq solver](https://quipqiup.com)
[decode tools](https://www.dcode.fr/tools-list#0)
[rsactftool](https://github.com/Ganapati/RsaCtfTool)
[cryptii pipeline](https://cryptii.com/)

## ssl / tls

[procedure](https://www.cloudflare.com/learning/ssl/what-happens-in-a-tls-handshake/)

## gpg

encrypt the message with public key and decrypt with private key.
so that we know that we are talking to the right person.

key server: `pgp.mit.edu`
generate key: `--full-generate-key`
generate key file: `--output <file> --armor --export <email>`
generate Revocation Certificate: `--output <file> --gen-revoke <email>`
import key file: `--import <file>`
show fingerprint: `--fingerprint <email>`, as a method to check keys
retrieve key from server: `--keyserver <server> --search-keys <email>`
send key to server: `--keyserver <server> --send-keys <fingerprint>`
sign keys: `--sign-key <email>`, as a method to adopt keys
encrypt and sign file: `--encrypt --sign --recipient <email> <file>`
decrypt: `--decrypt <file>`
show sign keys: ``
change trust level: `--edit-key <email>`

## code block

* electronic codebook (ECB)
  * same input always become the same output: `https://github.com/EiNSTeiN-/chosen-plaintext`
* cipher block chaining (CBC)
  * padding can leak information on intermediate state: `https://github.com/mwielgoszewski/python-paddingoracle`
