#!/bin/sh

stest () {
	section=$1; shift
	quoting=
	for q in "$@"; do
		q=`echo "$q" | tr '_' ' '`

		r=`echo x "$section" | sed -n "1s/^x //; /$q/s/^.*"\\\$"/$q/p;" | tr ' ' '_'`
		if test -z "$r"
		then :
		else echo x "$r" | sed '1s/^x //;'; return 0
		fi
	done
	return 1
}

modify_et_print() {
	bid=$1; format=$2; shift; shift
	sections=`echo "$format" | awk 'BEGIN { RS="[^-A-Za-z0-9_]" } { print $0 }' | tr '[A-Z]' '[a-z]' | tr '\012' ' '`

	for s in "$@"; do
		section=`echo "$s" | awk 'BEGIN { FS=":" } { if (NR == 1) { print $1 } }' | tr '[A-Z]' '[a-z]'`
		value=`echo "$s" | sed '1s/^[^:]*:[ 	]//'` # sed for a value contains a colon.

		if the_one=`stest "$section" $sections`; then
			# squotes
			value=`echo x "$value" | sed "s/'/'"'\\\\'"''/g; 1s/^x /'/; "'$s/$/'\'"/;"`
		else
			continue
		fi

		section=`echo x "$the_one" | sed '1s/^x //;' | tr '-' '_'`=
		eval "$section$value"
	done

		# sections surrounded by non-alphanums in each args
		# each line is one section.
		# modify to shell definition statement of variable.

	format=`echo x "$format" \
	  | tr '[A-Z]' '[a-z]' \
	  | tr '-' '_' \
	  | sed "
	    s/'/'"'\\\\'"''/g;
	    1s/x /'/; \\$s/\\$/'/;
	    s/"'\\([a-z0-9_][a-z0-9_]*\\)/'\\'\\"'\\$\\1'\\"\\''/g;'`

	if test -z "$bid"
	then :
	else while kill -0 "$bid" >/dev/null 2>&1; do :; done
	fi
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

	bid="$1" format="$2"; shift; shift;

	section= oldifs=$IFS; IFS=
	while read -r line; do
		IFS=$oldifs
		if test -n "${section:+x}"; then
			case "$line" in
			[\ \	]*)
				section="$section
$line"
				IFS=
				continue;;
			*)
				set x ${@:+"$@"} "$section"; shift
				;;
			esac
		fi
		section="$line"
		IFS=
	done
	IFS=$oldifs
	if test x"$section" = x"$line" \
	|| test 1 -lt `echo x "$section" | wc -l`; then
		set x ${@:+"$@"} "$section"; shift
	fi

	# $@ is some of "section:value".
	modify_et_print "$bid" "$format" "$@"
}
