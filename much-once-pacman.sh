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
RE=${1:-linux}
test $# -eq 0 || shift
while getopts n:lds o; do
	case "$o" in
	n) n=$OPTARG;;
	l) operate='-Q';;
	d) debug=`cat <<\EOL
echo >&2 x "$@" | sed '1s/^x //'
EOL`
	   ;;
	s) separately=1;;
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

start=`/bin/date '+%s'`
if test -n "$separately"; then
	for p in $pkgs; do
		pacman $operate -ii $p
	done
else
	pacman $operate -ii $pkgs
fi
end=`/bin/date '+%s'`
log "Time:" `expr $end - $start`s
