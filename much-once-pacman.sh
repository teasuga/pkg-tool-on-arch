#!/bin/sh
# SYNOPSIS
#   $0 'REGEX' [-nNumbers_to_pacman]

operate='-S'
log() {
	eval "$debug"
}
debug=:
n=20
OPTIND=1
separately=
back=
force=
RE=${1:-linux}
test $# -eq 0 || shift
while getopts n:ldsSf o; do
	case "$o" in
	n) n=$OPTARG;;
	l) operate='-Q';;
	d) debug=`cat <<\EOL
echo >&2 x "$@" | sed '1s/^x //'
EOL`
	   ;;
	S) separately=1; back=1;;
	s) separately=1;;
	f) force=1;;
	*) echo "Abort..."; exit 1;;
	esac
done ; shift `expr $OPTIND - 1`

pkgs=`pacman $operate -qs ${RE:-linux}`
l=`sed -n '/[^ 	]/p' <<EOL | wc -l
$pkgs
EOL`

r=`perl -e '$r = rand; print int($ARGV[0] * $r), "\n";' $l`

log "$r / $l"
test $n -le `expr $l - $r` || r=`expr $r - $n`
test $r -ge 1 || r=1
e=`expr $r + $n`; test $e -lt $l || e=$l

pkgs=`if test 1 -ne $n; then
	sed -n $r,${e}p <<EOL
$pkgs
EOL
else
	sed -n ${r}p <<EOL
$pkgs
EOL
fi`

if test 100 -gt $n || test -n "$force"; then
	:
elif test -n "$back"; then
	cat >&2 <<\EOL
Your PC may freeze because the numbers of processes which will system'()" is greater than or equal to 100.
And pid is plus 100, much processes will run in background.
So abort. That is ignored with -f flag.
EOL
		exit 2
else
	:
fi

bp=
trap '
	for p in $bp; do
		kill -0 $p >/dev/null 2>&1 && kill -9 "$p"
	done
' 1 2 3 15

start=`/bin/date '+%s'`
if test -n "$separately" && test -n "$back"; then
	for p in $pkgs; do
		pacman $operate -ii $p &
		bp="$bp $!"
	done
	wait
elif test -n "$separately" && test -z "$back"; then
	for p in $pkgs; do
		pacman $operate -ii $p
	done
else
	pacman $operate -ii $pkgs
fi
end=`/bin/date '+%s'`
log "Time:" `expr $end - $start`s
