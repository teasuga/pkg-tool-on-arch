# Experiment

## What's new
  It is faster than to separately system(pacman...) with each package (in background.).

## Options
    -n   the numbers of packages to system(pacman...) which matchs with REGEX. default is 20.
    -l   With local packages instead.
    -d   Evaluates time since starting to system().
    -s   Separately system(pacman...) on each package.

## How to use
    # separately system(pacman...)
    sh ./much-once-pacman.sh 'REGEX' [-nNUM] [-l] [-d] -s | grep ^Name | wc -l
    # pass all once
    sh ./much-once-pacman.sh 'REGEX' [-nNUM] [-l] [-d] | grep ^Name | wc -l
