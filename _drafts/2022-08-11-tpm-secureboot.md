---
layout: post
title:
date: 2022-08-11 06:20
category:
author:
tags: []
summary:
---

boot order: fw -> uefi -> linux kernel

EROT is a mechanism to protect firmware integrity. It can contain a number of pubkey signature which is used to verify that firmware is from a trusted source. EROT signature is usually fixed at the time of manufacturing.

Secure Boot is a mechanism to make sure the booting software is also signed by a trusted source. The signature is stored in TPM chip. But TPM chip content can be modifed by user.

## tpm

 ISO/IEC 11889

https://docs.microsoft.com/en-us/windows/security/information-protection/tpm/tpm-fundamentals

https://docs.microsoft.com/en-us/windows/security/information-protection/tpm/how-windows-uses-the-tpm

https://docs.microsoft.com/en-us/windows/security/information-protection/tpm/initialize-and-configure-ownership-of-the-tpm

https://docs.microsoft.com/en-us/windows/security/information-protection/tpm/tpm-recommendations

https://courses.cs.vt.edu/cs5204/fall10-kafura-BB/Papers/TPM/Intro-TPM.pdf

relationship with secure boot

## secure boot commands

```bash
mokutil --sb-state
sudo mokutil --disable-validation
sudo mokutil --enable-validation

sudo update-secureboot-policy --new-key

kmodsign

sudo mokutil --import

sudo update-secureboot-policy --enroll-key
```
