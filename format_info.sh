#!/bin/sh

alnums_=A-Za-z0-9_
safely_expr() {
	#unusual because if 1st parameter contains any of: ( ) [ ] ^ $ \
	#may be passed symbols like this: safely "(" "^\([^ALPHANUMS]\).*"
	#attentioned by expr.
	#so use `sed'
	#expr -- "$1" : "$2"
	#surround by x for an argument of 'echo' prefixed with `-'.
	result=`echo x "$1" x | sed -n "1s/^x //; \\$s/ x\$//; s/$2/"'\1/p'`
	echo "$result"
	test -n "${result:+x}"
}

sname() {
	safely_expr "$1" "^[^$alnums_]*\\([$alnums_][$alnums_]*\\).*"
}
upperize() {
	p=`safely_expr "$1" "^[^$alnums_]*\\([$alnums_]\\).*"` \
	  && echo "$p" | tr '[a-z]' '[A-Z]'
}
back_of() {
	safely_expr "$a" "^[^$alnums_]*[$alnums_]\\([$alnums_]*\\).*"
}
prefix() {
	safely_expr "$a" "^\\([^$alnums_][^$alnums_]*\\).*"
}
next() {
	safely_expr "$a" "^[^$alnums_]*[$alnums_][$alnums_]*\\([^$alnums_].*\\)\$"
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
		# sections surrounded by non-alphanums (+underscore) in each args
		# each line is contains one section.
		# modify to shell definition statement of variable.
		while sname=`sname "$a"` \
		  && sname=`echo "$sname" | tr '[A-Z]' '[a-z]'` # force changing to lowercase.
		do
		prefix=`prefix "$a"`
		plain_a="$plain_a$prefix$sname"
		next=`next "$a"`
		#by_space=`echo "$sname" | sed 's/_/ /g'`
		if_state="/$sname[^:]*:/ {"\
's/^[^:]*://; '\
's/^/'"$sname='/; "\
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
		while sname=`sname "$a"`
		do
		prefix=`prefix "$a" | squotes`
		next=`next "$a"`
		formats="$formats$prefix\"\$$sname\""
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
	eval "echo x $formats | sed '1s/^x //;'"
}

align_sections() {
	if test 2 > `echo "$1" | wc -l`; then
		:
	else
		echo 2>&1 "A newline cannot be in arguments! Will fixed soon."
		return 1
	fi
	# Debuggin will be tirely. but if not with perl,
	# changing a section in line only, use this.
	# It is out of above functions' scope in this 'while' block ?
	while read line; do
		section=`echo "$line" | sed 's/^\([^:]*\):.*$/\1/'`
		value=`echo "$line" | sed 's/^[^:]*:[ 	]*\(.*\)$/\1/'`

		section=`echo "$section" | sed 's/[ 	][	 ]*/ /g; s/[ 	]$//' | tr '[A-Z]' '[a-z]'`

		echo "$section:$value"
	done \
	  | format_info "$1"
	
}
