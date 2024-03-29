## setting up a workspace

there is 4 components that is involved:

- P4ROOT: the workspace path on local disk
- P4USER: the username
- P4PORT: the perforce server
- P4CLIENT: client name when setting up workspace
  - by using same cient name, perforce will copy over existing workspace setting

### .p4config

- put at root of workspace root for easy switching
  - no need to set up environment variable

## p4 client

- modify the options for the current workspace
- `-d`: remove a client (i.e. workspace)
- `Options`:
  - `nocompress`
  - `locked`: so that only owner can modify workspace
  - `modtime`: set file to modify time instead of sync time
  - `rmdir`: rm empty dir during perforce operation
- `Host`: removed if the workspace is on shared storage
- `SubmitOptions`:

### View

- inclusion:
  - `...` sync recursively
  - `\*` sync only files in current directory
- exclusion: `-`
- Overlay: `+`
  - put file from certain dir over another existing file at another position
- `ChangeView`: checkout from certain version
- Ditto: `&`
  - only the normal view can be edited
  - make file appear on different position

## p4 sync

- p4 does not actively check if files are modified
  - after you sync the file for the first time, p4 thinks you have it
    - even if we actually delete the file.
    - use `-f` to force a resync
  - but for files we do not want, removed from view is generally better
- `-n`: dry run, check to see which files will be updated
- `-q`: suppress normal output
- `-k`: ?

## p4 edit

- open the specified file as read-write
  - by default, files are opened read-only
- `-t`: type = specify how a file is stored
  - `+l`: exclusive lock
- `-c`: pending change list?

- `p4 add`: add new files to p4
- `p4 reopen -c`: move opened file into another CL

## p4 delete

- `-k`: leave file in workspace
- `-v`: delete file without sync it

## p4 move

```
p4 integ old new
p4 delete old
```

`p4 flush`: sync without file

## p4 opened

- `-a`: who has file opened
- `-c`: what is opened in CL
- `-C`: what is opened in workspace
- `-u`: what has user opened
- `-s`: summary ?

## p4 revert

- revert in current workspace
- `-a`: revert if unchanged
- `-k`: keep changes in workspace
- `-w`: remove if added

## p4 change

- create a numbered changelist
  - vs default changelist
- `p4 reopen` for moving files between changelist
- `-u`: update a submitted changelist

## p4 changes

- filter changelist on the server
  - will list out all changelist if no parameter is given
- `-u`: user name
- `-s`: status
  - `pending`, `submitted`, `shelved`

## p4 shelve / p4 unshelve

- temporarily store your changes on the server
  - allow changes to be shared
- `shelve -r`: replace shelved files with local version
- `shelve -d`: remove files from shelf

- `unshelve -s`: restore shelved files

## p4 submit

- `-c CL`: submit files in CL
- `-e CL`: submit shelved CL

## history

- `p4 changes` get submitted, pending, shelved CL
- `p4 filelog` get file CL
- `p4 annotate` get line with revision
- `p4 describe` get content of CL

## p4 files / dirs / print

look at server files without sync

## p4 branch / integ

- integrate file from one depot to another
- integrate takes a intersection from workspace and branch flow
- instead of hand picking what file to integrate each time, we can use branchview
  - setup a static integration path for repeating integration
  - find out what branch exist `p4 branches -e <branch name regex>`
- `p4 integrate -b branchname -s fromFile[revRange] `

## p4 resolve / resolved

## p4 label

- cherry pick the golden version
  - even from different CL
- label does not have a history
  - create and never change it again

labelsync

## p4 user

CODEOWNERS

## p4 block

block other from committing a file

## p4 where

show how files would be mapped

p4 have: see what is available in workspace

## blame

`p4 filelog`: for file history
`p4 annoate`: line by line changes
`p4 describe -S <cl>`: view change in cl
