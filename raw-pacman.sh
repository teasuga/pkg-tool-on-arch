#!/bin/sh

format=
if test $# -gt 1; then
    format=$1
    shift
else
    :
fi
format=${format:-'name # version'}

start=`/bin/date '+%s'`
pacman -Sii "${@-linux}"
end=`/bin/date '+%s'`
echo >&2 "Time:" `expr $end - $start`s
