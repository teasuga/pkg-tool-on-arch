#!/bin/sh

safely_expr() {
	#unusual because if 1st parameter contains any of: ( ) [ ] ^ $ \
	#may be passed symbols like this: safely "(" "^\([^ALPHANUMS]\).*"
	#attentioned by expr.
	#so use `sed'
	#expr -- "$1" : "$2"
	result=`echo "$1" | sed -n "s/$2/"'\1/p'`
	echo "$result"
	test -n "${result}"
}

upperize() {
	p=`safely_expr "$1" '^[^A-Za-z0-9]*\([A-Za-z0-9]\).*'` \
	  && echo "$p" | tr '[a-z]' '[A-Z]'
}
back_of() {
	safely_expr "$a" '^[^A-Za-z0-9]*[A-Za-z0-9]\([A-Za-z0-9]*\).*'
}
prefix() {
	safely_expr "$a" '^\([^A-Za-z0-9][^A-Za-z0-9]*\).*'
}
next() {
	safely_expr "$a" '^[^A-Za-z0-9]*[A-Za-z0-9][A-Za-z0-9]*\([^A-Za-z0-9].*\)$'
}
squotes() {
	sed "s/'/'"'\\'"''/g; 1s/^/'/; "'$s/$/'\'/\;
}

format_info() {
	cat <<\EOL >/dev/null
	pacman output arguments on each line. 
	declare a var, remove a NL.

	arguments is named alphabetical. and value is from a colon.
	prefix with ARG=, value surrounded by "sigle-quote"s.
	so exchange ' to '\''
	Like:
		ARG=''\''Sigle quote is '\''. It'\''s safely contained.'
		ARG='If on the end, like this: '\'''

	And passed to eval:
		eval "$definitions"
EOL

	for a in "$@"; do
		plain_a= next=
		while upperize=`upperize "$a"`
		do
		not_care=`back_of "$a"`
		prefix=`prefix "$a"`
		plain_a="$plain_a$prefix$upperize$not_care"
		next=`next "$a"`
		a="$upperize$not_care"
		if_state="/$a/ {"\
's/^[^:]*:[ 	]//; '\
's/^/'"$a='/; "\
"s/'/'\\''/g; "\
"s/"\$"/'/; "\
"p; "\
"bend; "\
"}; "
		if_states="$if_states$if_state"
		a=$next
		done
		shift; set dummy ${@+"$@"} "$plain_a$next"; shift
	done
	if_states="$if_states :end; "

	definitions=`sed -n "$if_states"`

	eval "$definitions"

	formats=
	for a in "$@"; do
		plain_a= next=
		while upperize=`upperize "$a"`
		do
		not_care=`back_of "$a"`
		prefix=`prefix "$a" | squotes`
		next=`next "$a"`
		a=$upperize$not_care
		formats="$formats$prefix\"\$$a\""
		a=$next
		done
		if test ${next:+x}; then
			next=`echo "$next" | squotes`
			formats="$formats$next"
		else
			:
		fi
		formats="$formats "
	done
	eval "echo x $formats x | sed '1s/^x //; \$s/ x\$//;'"
}
