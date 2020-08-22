# branch: summer.20

for my tool 'pkg'.

# How to use

## Create a script on $script_home, and edit with $EDITOR.

$ pkg edit A_NAME

## Packaging the script. (also installing by 'makepkg -i' if -i flag is on)

$ pkg create [-i] [-oMAKEPKG_OPTIONS] A_NAME

## Print formatted description of a package. -l for local packages, -r for remotely packages.

$ pkg [-l|-r] 'SECTIONS' A_NAME # sections in one line from pacman's output

$ pkg [-l|-r] info [-v] A_NAME # pacman $operate -i $verbosely A_NAME

$ pkg [-l|-r] v A_NAME # version only

$ pkg [-l|-r] s A_NAME # short format (Name Version)

$ pkg [-l|-r] p A_NAME # packager only

$ pkg [-l|-r] [-f FORMAT]  match REGEX... # search by regex and format info


# Examples

$ pkg edit recent_log # creates $HOME/scripts/recent_log/recent_log

$ pkg create -i recent_log.pl # create a package of it ($HOME/scripts/recent_log/recent_log-1-1.pkg.tar.**), and install it.

$ pkg 'build' linux # grep 'build' from pacman -Sii linux

Thu 13 Aug 2020 03:50:43 AM JS

$ pkg -l info -v linux # do 'pacman -Qi -i linux'

$ pkg info linux # do 'pacman -Si linux'

$ pkg -l 'name#repo ver' linux # from pacman -Qii linux

linux#core 5.8.1.arch1-1

$ pkg -f'name#repo ver' match xkb # search regex and format

xorg-xkbcomp

...
