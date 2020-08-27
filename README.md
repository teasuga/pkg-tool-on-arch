## News
  A bug is.
  
## A IMPORTANT BUG
  Optional Deps on multiple lines, so NOT CORRECTLY INFORMATIONS from a function.
  
## Files
  1. pkg (creation of package which contains one script, editing its script, print a package's brief in one line by using format_info.sh.)
  2. format_info.sh (get stdout of pacman, and only print sections specified on command line.)

## Run locally
  $ git clone --branch underscore_as_space https://github.com/teasuga/pkg-tool-on-arch.git

  $ cd pkg-tool-on-arch

  $ sh ./pkg 'name / version # repo' pacman

## Install them
  $ PATH_DIR=/where/pkg/sit/on ; FUNC_HOME=/where/func_info.sh/sit/on # set variables

  $ install -m755 -t $PATH_DIR ./pkg # to execute on your shell.

  $ install -m644 -t $FUNC_HOME ./format_info.sh # sourced format_info.sh from pkg

  $ sed -i '/^func_home=/s|=.\*|='"$FUNC_HOME"'|' "$PATH_DIR/pkg" # set func_home variable to above one

## And run on a system
  $ pkg 'version @ build' systemd
  
## Remove them
  $ rm "$PATH_DIR/pkg"

  $ rm "$FUNC_HOME/format_info.sh"

## How to use

\# global options: [-l|-r] (local, from remote database) , -f specify formats

## Create a script on $script_home, and edit with $EDITOR.

$ pkg edit A_NAME

## Packaging the script. (also installing by 'makepkg -i' if -i flag is on)

$ pkg create [-i] [-oMAKEPKG_OPTIONS] A_NAME

## Print formatted description of a package.

\# global options: -C to copy to clipboad , -s short format (Name Version${NEWLINE}Description), -n add name to formats , -v add version to formats , -d add build to formats (may be Build Date).

$ pkg [-fFORMAT] match REGEX... # search packages by regex and format info

$ pkg 'SECTIONS' PACKAGE... # like -f option, but sections in one line from pacman's output

$ pkg v PACKAGE... # like -v option, but version only

$ pkg s PACKAGE... # like -s option, but "Name Version" only

$ pkg p PACKAGE... # like them, but packager only

## Just do pacman $operate -i $verbosely PACKAGE...

$ pkg info [-v] PACKAGE...

## from information of local packages.

$ pkg [-Csnvd] [-fFORMAT] installed PACKAGE...

# Examples

$ pkg edit recent_log # creates $HOME/scripts/recent_log/recent_log

$ pkg create -i recent_log.pl # create a package of it ($HOME/scripts/recent_log/recent_log-1-1.pkg.tar.\*), and install it.

$ pkg -C 'name: build_date' linux # copy to clipboad that "linux: Thu 13 Aug 2020 03:50:43 AM JS"

$ pkg -l 'name#repo ver' pacman # from pacman -Qii pacman

linux#core 5.8.1.arch1-1

$ pkg -l v systemd # the version of local 'systemd' is

246.2-1

$ pkg -l info -v coreutils # do 'pacman -Qi -i coreutils'

$ pkg info linux # do 'pacman -Si linux'

$ pkg -f'name#repo ver' match xkb # search regex and format

xorg-setxkbmap#extra 1.3.2-2

...
