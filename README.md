# Experiment
  For making 'match' sane.

## What's new
  It is faster than to separately system(pacman...) with each package (in background.).

## Options
    -n   the numbers of packages to system(pacman...) which matchs with REGEX. default is 20.
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
