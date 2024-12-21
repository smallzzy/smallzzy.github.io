---
layout: post
title:
date: 2024-12-20 12:50
category:
author:
tags: []
summary:
---

## list of commands

```bash
bsub: submit a job
bjobs: review job status
bstop <jobid>: stop a job
bresume <jobid>: resume a job
bkill <jobid>: kill a job
bqueues: list available queues
```

## environment variables

https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=variables-environment-set-job-execution

> In addition to environment variables inherited from the user environment, LSF also sets several other environment variables for batch jobs.

## bsub

```bash
-q ${QUEUE} : queue name

-n ${CORES} : number of cores
-R 'span[hosts=1]': Span string

-Is: Submits an interactive job and creates a pseudo-terminal with shell mode when the job starts.

-o <file1> -e <file2>: write stdout to file1, stderr to file2
```

## job states

https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=execution-about-job-states

## Span string

Used to specify how number of cores are split across nodes

https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=strings-span-string

## bqueues

https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-bqueues

## lsmake

https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-lsmake#v4526949


## what entiy are involved

https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=lsf-daemons

## distriubted compiling?

https://github.com/bazelbuild/remote-apis

https://bazel.build/community/remote-execution-services
