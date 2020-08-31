# pkg-tool-on-arch
A tool to do something packages on Arch Linux. The name is from a shell script.

There is my tool 'pkg' on branches: "summer.20", "underscore_as_space", "with_newline", "pkg", "format_info.sh".

## Latest commit (branch) is
  "pkg" or "format_info.sh"

## Bugs on latest commit
  please test like this before install them: sh ./pkg 'name@url' coreutils

## DO NOT THIS on latest branch BECAUSE MAY FREEZE YOUR PC:
  sh ./pkg -f'FORMAT' match REGEX...

## Features
  1. Easily editing a script, and packaging it.
  2. Only print sections of packages you specify, modify to a format you specify.

## Rely on commands
  * pacman
  * makepkg
  * wc
  * sed
  * pkgfile
  * xsel
  * cat
  * dirname
  * updpkgsums
