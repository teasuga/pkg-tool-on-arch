## What's new (may has a bug)
   1. Able to get sections over lines,
   2. Proceed speedy (by being "pacman -Sii"s on background)
   3. (with the branch "format_info.sh"'s).

## A IMPORTANTLY BUG IS
   Fixed: (Optional Deps on multiple lines, so COMPLETELY NO CORRECT INFORMATION from output of this script.)

   MAY FREEZE YOUR PC if you specify 'match' argument with parameters because many pacman processes will run simultaneously.
   
   This bug will fixed by limiting processes which system() "pacman".

## Files
  1. pkg (creation of package which contains one script, editing its script, print a package's brief in one line by using format_info.sh.)
  2. format_info.sh (get stdout of pacman, and only print sections specified on command line.)

## Run locally

    git clone --branch with_newline https://github.com/teasuga/pkg-tool-on-arch.git
    cd pkg-tool-on-arch
    sh ./pkg 'name ver (build_date)
        desc' pacman

## Install them
    PATH_DIR=/where/pkg/sit/on ; FUNC_HOME=/where/func_info.sh/sit/on # set variables
    install -m755 -t $PATH_DIR ./pkg # to execute on your shell.
    install -m644 -t $FUNC_HOME ./format_info.sh # sourced format_info.sh from pkg
    sed -i '/^func_home=/s|=.\*|='"$FUNC_HOME"'|' "$PATH_DIR/pkg" # set func_home variable to above one

## And run on a system
    pkg 'version @ build_date' systemd
  
## Remove them
    rm "$PATH_DIR/pkg"
    rm "$FUNC_HOME/format_info.sh"

## How to use

Global options: [-l|-r] (local, from remote database) , -f specify formats

## Create a script on $script_home, and edit with $EDITOR.

    pkg edit A_NAME

## Packaging the script. (also installing by 'makepkg -i' if -i flag is on)

    pkg create [-i] [-oMAKEPKG_OPTIONS] A_NAME

## Print formatted description of a package.

    # Global options: -C to copy to clipboad , -s short format (Name Version${NEWLINE}Description), -n add name to formats , -v add version to formats , -d add build to formats (may be Build Date).

    # DO NOT THIS.
    pkg [-fFORMAT] match REGEX... # search packages by regex and format info

    pkg 'FORMAT' PACKAGE... # like -f option, but sections in one line from pacman's output
    pkg v PACKAGE... # like -v option, but version only
    pkg s PACKAGE... # like -s option, but "Name Version" only
    pkg p PACKAGE... # like them, but packager only

## Just do pacman $operate -i $verbosely PACKAGE...

    pkg info [-v] PACKAGE...

## from information of local packages.

    pkg [-Csnvd] [-fFORMAT] installed PACKAGE...

# Examples

    $ pkg edit recent_log # creates $HOME/scripts/recent_log/recent_log
    $ pkg create -i recent_log.pl # create a package of it ($HOME/scripts/recent_log/recent_log-1-1.pkg.tar.\*), and install it.
    $ pkg -C 'name: build' linux # copy to clipboad that "linux: Thu 13 Aug 2020 03:50:43 AM JS"
    $ pkg -l 'name#repo ver' linux # from pacman -Qii linux
    linux#core 5.8.1.arch1-1
    $ pkg -l v systemd # the version of local 'systemd' is
    246.2-1
    $ pkg -l info -v linux # do 'pacman -Qi -i linux'
    $ pkg info linux # do 'pacman -Si linux'
    
    # DO NOT THIS.
    $ pkg -f'name#repo ver' match xkb # search regex and format
    xorg-setxkbmap#extra 1.3.2-2
    ...
