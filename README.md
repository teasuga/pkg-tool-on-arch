# pkg-tool-on-arch
A tool to do something packages on Arch Linux. The name is from a shell script.

There is my tool 'pkg' on branches: "fall.20".

## Latest commit (branch) is
  "fall.20"

## Bugs
  No bugs are maybe. To find bugs, pass shell -x to view final command line or var assignment:
    sh -x ./pkg 'name@url' coreutils
  # optionally -e for aborting if that are false. e.g.:
    false && true
    if false; then true; fi
    # var=`false; echo maybe continue...`

  Or please read files.
