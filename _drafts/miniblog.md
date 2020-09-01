https://www.felixcloutier.com/x86/
https://en.wikibooks.org/wiki/X86_Assembly/X86_Architecture

## pwnlib
* tube
  * interactive
* context.log_level
* packing

skype security?

https://httpie.org/docs
time +%s%3N



## file log

lsof: list process that opened a file
LoggedFS: 
audit subsystem

fopen c11 wx: do not write if exist
fopen vs open
open: fd remains unless FD_CLOEXEC


https://www.cs.miami.edu/home/burt/learning/Csc524.032/notes/tcp_nutshell.html
 http.content_type == "application/json"
http contains

fork() return 0 for child
pthread_atfork()

strerror_r()


# irc
network - represent group of server
* most server are configured through dns instead?
* infomation is shared in one network
server - single server
channel - where people talk

/network add
/server add
/channel add

sasl?

/connect to network
/quit
/join to channel
/part

/msg, notice
/whois

/links
/list
/names

https://gist.github.com/xero/2d6e4b061b4ecbeb9f99
https://stackoverflow.com/questions/31666247/what-is-the-difference-between-the-nick-username-and-real-name-in-irc-and-wha

## gc

https://medium.com/a-journey-with-go/go-how-does-the-garbage-collector-mark-the-memory-72cfc12c6976
https://medium.com/a-journey-with-go/go-memory-management-and-allocation-a7396d430f44
https://spin.atomicobject.com/2014/09/03/visualizing-garbage-collection-algorithms/

zgc?
c4
tri-color

# vpn?

maxmind
mysterium.network
wireguard
https://www.reddit.com/r/ethereum/comments/6eznfj/my_thoughts_on_mysterium_network_and_how_its_a/

## android reverse

jadx
https://mobile-security.gitbook.io/mobile-security-testing-guide/android-testing-guide/0x05c-reverse-engineering-and-tampering#reverse-engineering
https://github.com/iBotPeaches/Apktool
https://github.com/pxb1988/dex2jar
https://github.com/Storyyeller/enjarify
https://github.com/leibnitz27/cfr
https://github.com/JesusFreke/smali
https://github.com/JesusFreke/smalidea
https://bitbucket.org/mstrobel/procyon/wiki/Java%20Decompiler
https://github.com/Storyyeller/Krakatau
https://github.com/JetBrains/intellij-community/tree/master/plugins/java-decompiler/engine
https://github.com/java-decompiler/jd-gui

## some library

https://github.com/google/gson
https://github.com/DrTimothyAldenDavis/SuiteSparse
https://github.com/DrTimothyAldenDavis/GraphBLAS
openpd

## go debug

dlv debug --headless --listen=localhost:2345 --api-version=2 -- <args>

```
{
    "name": "Remote Debug",
    "type": "go",
    "request": "attach",
    "mode": "remote",
    "remotePath": "${workspaceFolder}",
    "port": 2345,
    "host": "localhost",
}
```

go protobuf

* install protoc
* go install google.golang.org/protobuf/cmd/protoc-gen-go
* protoc
  * proto_path
    * if message are defined in several files, all source need to be included in this directory
  * go_out -> all generated file will be relative to this dir
  * `option go_package "full path";` generated into this path relative to go_out
    * --go_out=$GOPATH: so that pb file becomes its own package for import 
  * go_opt=paths=source_relative -> generated files are placed in output dir based on source's relative position vs proto_path
    * ignores go_package setting
    * embedded into current directory

## rar

https://www.rarlab.com/technote.htm#arclayout
https://www.winrar-france.fr/winrar_instructions_for_use/source/html/HELPCmdRR.htm
rar recover record is calculated per file
even with multiple volume

## hex editor

okteta
101 editor
hex fiend
hachoir
