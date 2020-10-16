# Experiment
  For making 'match' sane.

## What's new
  It is faster than to separately system(pacman...) with each package (in background.).

## Options
    -n   the numbers of packages to system(pacman...) which matchs with REGEX. default is 20.
    -r   From 'r'th package.
    -l   With local packages instead.
    -d   Evaluates time since starting to system().
    -s   Separately system(pacman...) on each package.
    -S   Separately, and do on background.
    -f   Force to system() on backround whether the numbers is less than 100 or not.

## How to use
    # separately system(pacman...)
    sh ./much-once-pacman.sh 'REGEX' [-nNUM] [-l] [-d] -s | grep ^Name | wc -l
    # pass all once
    sh ./much-once-pacman.sh 'REGEX' [-nNUM] [-l] [-d] | grep ^Name | wc -l
    # separately system(pacman...) on background.
    sh ./much-once-pacman.sh 'REGEX' [-nNUM] [-l] [-d] -S [-f] | grep ^Name | wc -l
    # 50 packages which match with REGEX "linux", separately run on background, evaluates time.
    sh ./much-once-pacman.sh '' -n50 -d -S | grep ^Name | wc -l
    # 100 packages, run separately on foreground,
    # and calculate time.
    ( i=1; n=20
    while sh ./much-once-pacman.sh '' -r$i -n$n
    do i=`expr "$i" + "$n"`
    done >&2
    ) | ( s=0
    while :
    do read num || break
       s=`expr $s + $num`
    done
    echo >&2 Time: "$s" secs
    )
