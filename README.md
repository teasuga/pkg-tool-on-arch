# pkg-tool-on-arch
A tool to do something packages on Arch Linux. The name is from a shell script.

There is my tool 'pkg' on branches: "fall.20".

## Latest commit (branch) is
  "fall.20"

## Bugs
  No bugs are maybe. To find bugs, pass shell -x to view final command line or var assignment:
    sh -x ./pkg 'name@url' coreutils
  # optionally -e for aborting if that are false. e.g.:
```shell
#!/bin/sh
## Save the below script to the file to
## current working directory. And run:
# for i in 1 2 3; do sh ./abort.sh $i; done

set -e
case "${1:-1}" in 1)
  false && true; echo 1
;; 2)
  if false; then true; fi; echo 2
;; 3)
  var=`false && true`; echo 3
;; esac
```
  Or please read files.
