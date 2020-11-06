## News
  1. No debug yet.
  2. Enough speed for me.
  3. One pacman process run with many packages on foreground.
  
## A IMPORTANTLY BUG IS
   Fixed: (Optional Deps on multiple lines, so COMPLETELY NO CORRECT INFORMATION from output of this script.)

   Fixed: MAY FREEZE YOUR PC if you specify 'match' argument with parameters because many pacman processes will run simultaneously.
   
   Limited: This bug will fixed by limiting processes which system() "pacman".

## Files
  1. pkg (creation of package which contains one script, editing its script, print a package's brief in one line by using format_info.sh.)
  2. format_info.sh (get stdout of pacman, and only print sections specified on command line.)

## Run locally

    git clone --branch new-format_info.sh https://github.com/teasuga/pkg-tool-on-arch.git
    cd pkg-tool-on-arch
    sh ./pkg 'name ver (build_date)
        desc' pacman

## Install them
    PATH_DIR=/where/pkg/sit/on ; FUNC_HOME=/where/func_info.sh/sit/on # set variables
    install -Dm755 -t $PATH_DIR ./pkg # to execute on your shell.
    install -Dm644 -t $FUNC_HOME ./format_info.sh # sourced format_info.sh from pkg
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

formating options:  -s space, -n name, -v version, -d build_dates, -p packager, -i line feed, -f explict FORMAT is, -u add to FORMAT instead.

other options: -C to copy to clipboad, -l local packages, -r from packages synced with remote.

    pkg 'FORMAT' PACKAGE... # same to, pkg -f'FORMAT' info PACKAGE...
    # you must specify formating options to below three cmds
    # or change default FORMAT in "pkg".
    pkg match REGEX... # search packages by regex and format info
    pkg info PACKAGE...
    pkg installed PACKAGE... # info of local packages

# Examples

    pkg edit recent_log # creates $HOME/scripts/recent_log/recent_log
    pkg create -i recent_log.pl # create a package of it ($HOME/scripts/recent_log/recent_log-1-1.pkg.tar.\*), and install it.
    # a optional line-feed is printed by some versions of "format_info()".
    pkg -C 'name: build' linux # copy to clipboad that "linux: Thu 13 Aug 2020 03:50:43 AM JS"
    pkg -l 'name#repo ver' linux # from pacman -Qii linux
    pkg -l version systemd # the version of local 'systemd'.
    pkg -nsvi -uBackup_files installed pacman # "name version\nbackup-file-1\n..."
    pkg -nsvi info pacman # "name version\n"
    pkg -f'name#repo ver' match xkb # search regex and format
