## News
  1. No debug yet.
  2. Enough speed for me.
  3. One pacman process run with many packages on foreground.
  
## A IMPORTANT BUG
  Fixed: Optional Deps on multiple lines, so NOT CORRECTLY INFORMATIONS from a function.
  
## Files
  1. pkg (creation of package which contains one script, editing its script, print a package's brief in one line by using format_info.sh.)
  2. format_info.sh (get stdout of pacman, and only print sections specified on command line.)

## Run locally
  $ git clone --branch summer.20 https://github.com/teasuga/pkg-tool-on-arch.git

  $ cd pkg-tool-on-arch

  $ sh ./pkg 'name / version # repo' pacman

## Install them
  $ PATH_DIR=/where/pkg/sit/on ; FUNC_HOME=/where/func_info.sh/sit/on # set variables

  $ install -Dm755 -t $PATH_DIR ./pkg # to execute on your shell.

  $ install -Dm644 -t $FUNC_HOME ./format_info.sh # sourced format_info.sh from pkg

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
## Just do pacman $operate -i $verbosely PACKAGE...

$ pkg info PACKAGE...

## from information of local packages.

$ pkg [-Csnvd] [-fFORMAT] installed PACKAGE...

# Examples

$ pkg edit recent_log # creates $HOME/scripts/recent_log/recent_log

$ pkg create -i recent_log.pl # create a package of it ($HOME/scripts/recent_log/recent_log-1-1.pkg.tar.\*), and install it.

$ pkg -C 'name: build' linux # copy to clipboad that "linux: Thu 13 Aug 2020 03:50:43 AM JS"

$ pkg -l 'name#repo ver' linux # from pacman -Qii linux

linux#core 5.8.1.arch1-1

$ pkg -l version systemd # the version of local 'systemd' is

246.2-1

$ pkg -nsvi -uBackup_files installed pacman # "name version\nbackup-file-1\n..."

$ pkg -nsvi info pacman # "name version\n"

$ pkg -f'name#repo ver' match xkb # search regex and format

xorg-setxkbmap#extra 1.3.2-2

...
