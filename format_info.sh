#!/bin/sh

modify_et_print() {
	sections=`echo "$1" | awk 'BEGIN { RS="[^-A-Za-z_]" } { print $0 }' | tr '\012' ' '`

	while read line; do
	for s in $sections
	do
		# sections surrounded by non-alphanums in each args
		# each line is one section.
		# modify to shell definition statement of variable.
		spacized_s=`echo "$s" | tr '_' ' '`
		underscorized_s=`echo "$s" | tr '-' '_'`

		definition=`echo x "$line" | sed -n "1s/^x //; /$spacized_s[^:]*:/ {
			s/^[^:]*:[ 	]//; s/'/'"'\\\\'"''/g;  s/\\$/'/; s/^/$underscorized_s='/p; }"`
		if test -n "${definition:+x}"; then
			eval "$definition"
		else
			continue
		fi
	done
	done

	format=`echo x "$1" \
	  | tr '[A-Z]' '[a-z]' \
	  | tr '-' '_' \
	  | sed "
	    s/'/'"'\\\\'"''/g;
	    1s/x /'/; \\$s/\\$/'/;
	    s/"'\\([a-z0-9_][a-z0-9_]*\\)/'\\'\\"'\\$\\1'\\"\\''/g;'`

	eval "echo x $format | sed '1s/^x //;'"
}

format_info() {
	cat <<\EOL >/dev/null
	pacman output arguments on each line. 
	get alphanumsly vars, sed's greping and change value to definition.
	eval definition

	squotes non-alphanums, prefix alphanums with dollar and dquotes.
	eval modified argument

	arguments is named alphanums or hiphens, underscores.
	and section's value is from a colon.
	prefix with SECTION=, value surrounded by "sigle-quote"s.
	so exchange ' to '\''
	Like:
		SECTION=''\''Sigle quote is '\''. It'\''s safely contained.'
		SECTION='If on the end, like this: '\'''

	And passed to eval:
		eval "$definition"
EOL

	while read line; do
		section=`echo "$line" | awk 'BEGIN { FS=":" } { print $1 }' | tr '[A-Z]' '[a-z]'`
		value=`echo "$line" | awk 'BEGIN { FS=":" } { print $2 }'`
		echo "$section:$value"
	done \
	  | modify_et_print "$1"
}
