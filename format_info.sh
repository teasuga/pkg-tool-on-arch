#!/bin/sh

upper=ABCDEFGHIJKLMNOPQRSTUVWXYZ
lower=`tr '[A-Z]' '[a-z]' << EOL
$upper
EOL`
alnums='-A-Za-z0-9_'
alnums_b='A-Za-z0-9_'
non_alnums="[^$alnums]"
non_alnums_s="[^$alnums_b]"
alnums="[$alnums]"
alnums_s="[$alnums_b]"

tab=`echo x | tr 'x' '\011'`
unknown_values() {
	# Maybe it takes much time to do this.
	# If you found something that I didnt expect, please report.
	# Note: I dont read and verify by sources of pacman.
	pacman ${1--Q} -ii | sed "
		/^[-A-Za-z0-9 ][-A-Za-z0-9 ]*  *:/ {
			h;
			s/^[^:][^:]*://;
			/^\( \|$\)/d
			x; n;
		}
		"'/\(^(none)$\|^[A-Z][A-Z]*'"$tab"'\|^  *\)/ {
			d
		}
		/^$/d
	' | sort -u
}
evaluates() {
    format=`echo 3 "$2" | sed "
        1s/^3 //;
        s/$alnums_s$alnums_s*/"'\\\$P&/g;' \
      | tr '[a-z]' '[A-Z]'`
    sections=$1

	for s in $sections; do
		eval "P$s="
	done
	while :; do
		read line || break
		case "$line" in
		'')
            eval 'cat << EOL
'"$format"'
EOL'
			for s in $sections; do
				eval "P$s="
			done
			;;
		*)
			s=`echo x "$line" | sed 's/x //; s/=.*$//;'`
			eval "b=\$$s"
			eval "$line"
			test -z ${b:+x} || eval "$s"'="$b
$'"$s"\"
			s=
			;;
		esac
	done
	if test x"$line" = x
	then :
	else
            eval 'cat << EOL
'"$format"'
EOL'
	fi
}
	
seding() {
	sections=$1

	if_states=
	for s in $sections; do
		if_state="
	/$s/ {
		s/^.*\$/$s/;
		bwords;
	}
"
		if_states="$if_states$if_state"
	done

#	backup_files='/\(^(none)$\|^\(UNREADABLE\|UNMODIFIED\|MODIFIED\)'"$tab"'\)/ {

	backup_files='/\(^[A-Z][A-Z]*'"$tab"'\)/ {
		bquote;
	}'
	sed "
	$backup_files
	/^$alnums/ {
		h;
		s/[ 	][ 	]*:.*//;
		y/${lower} -/${upper}__/;
		x;
		s/^[^:][^:]*://; s/^ //;
		bquote;
	}
	/^$non_alnums/ {
		bquote;
	}"'
	/^$/ {
		p;
	}
	s/^.*$//; x; d;
	
	:quote;'"
	s/'/'"'\\'"''/g;
	s/\$/'/;"'
	s/\\/\\\\/g;'"
	x;

$if_states"'
    s/^.*$//; x; d;
    :words;
    x; G;
        s/^\([^\n][^\n]*\)\n\(.*\)$/P\2='\''\1/;
    '
}

format_info() {
	sections=`awk 'BEGIN {RS="'"$non_alnums_s"'"} { print $0 }' << EOL | tr '[a-z\n]' '[A-Z ]'
$1
EOL
`
	seding "$sections" | evaluates "$sections" "$1"
}
