#!/bin/sh

upper=ABCDEFGHIJKLMNOPQRSTUVWXYZ
lower=`tr '[A-Z]' '[a-z]' << EOL
$upper
EOL`
alnums='-A-Za-z0-9_'
non_alnums="[^$alnums]"
alnums="[$alnums]"


evaluates() {
    format=`echo 2 "$2" | sed "
        1s/^2 //;
        s/$alnums$alnums*/"'\\\$&/g;' \
      | tr '[a-z-]' '[A-Z_]'`
    sections=$1

	for s in $sections; do
		eval "$s="
	done
	while :; do
		read line || break
		case "$line" in
		'')
            eval 'cat << EOL
'"$format"'
EOL'
			for s in $sections; do
				eval "$s="
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

	sed "
	/^$alnums/ {
		h;
		s/[ 	][ 	]*:.*//;
		y/${lower} -/${upper}__/;
		x;
		s/^[^:][^:]*:[	 ]//;
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
        s/^\([^\n][^\n]*\)\n\(.*\)$/\2='\''\1/;
    '
}

format_info() {
	sections=`awk 'BEGIN {RS="'"$non_alnums"'"} { print $0 }' << EOL | tr '[a-z-\n \t]' '[A-Z_   ]'
$1
EOL
`
	seding "$sections" | evaluates "$sections" "$1"
}
