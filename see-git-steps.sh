#!/bin/bash

# initialize
VERSION="0.5.0"
TEST=0
VERBOSE=0
SMART=0
COMMIT=0
INTERACTION=0
QUESTION=0

# functions

# The script version
#
# Returns:
#   string: version number
function version {
    echo "See git steps: $VERSION"
}

# The script help
#
# Returns:
#   string: script manual
function help {
    cat <<EOF
see-git-steps(1) -- See git commits step by step
=================================

## SYNOPSIS

\`see-git-steps\` [-hVtvis] [-c \`commit\`]

## OPTIONS

  \`-h, --help\`              display this message

  \`-V, --version\`           output version

  \`-t, --test\`              display the result of the basic test

  \`-v, --verbose\`           enable verbose output

  \`-c, --commit\`            number of \`commit\` where to start

  \`-i, --interaction\`       display one commit at a time and expect enter or [yY] to display the next commit

  \`-s, --skip-question\`     no display the question between each commit

## USAGE

  This script works if you have installed on your device the git program

    $ see-git-steps -t

  display OK if you have installed on your device git program,
  display KO if you don't have installed on your device git program

    $ see-git-steps -c 9680dc4

  display only description of the commits from old to new until the \`commit\`,
  then if the description starts with \`step [0-9]*\`, display also the file of the commit

    $ see-git-steps -c 9680dc4 -v

  display only description of the commits from old to new until the \`commit\`,
  then display the file of the commit and if the description starts with \`step [0-9]*\`, display also the diff

    $ see-git-steps -v -i -s

  display one commit at a time and expect enter or [yY] to display the next commit,
  display the file of the commit and if the description starts with \`step [0-9]*\`, display also the diff

## AUTHOR

  Alessandra Bilardi <alessandra.bilardi@gmail.com>

## REPORTING BUGS

  https://github.com/bilardi/see-git-steps/issues

## SEE ALSO

  \`git\`(1), \`git-log\`(1)

## LICENSE

  MIT (C) Copyright Alessandra Bilardi 2016

EOF
    exit 1
}

# Echo of the red message in STDERR
#
# Args:
#   message: string: error message
# Returns:
#   string: the red message in STDERR
function error {
    echo -e "\033[0;31m$@\033[0m" 1>&2
}

# Test if git is installed
#
# Returns:
#   mixed: string: OK, KO or error message
function gitTest {
    local isInstalled=1
    local gitVersion=$(git --version | sed 's/^[^0-9]*\([0-9\.]*\)[^0-9]*$/\1/i')
    local gitVersionLevel=$(echo ${gitVersion%%.*})
    if [[ ! "$gitVersionLevel" =~ ^[0-9]+$ ]]; then
	isInstalled=0
    fi
    if [[ "$isInstalled" == "0" ]] && [[ "$TEST" == "0" ]]; then
	error 'Error: this script uses git program and git is not installed!'
	help
    elif [[ "$isInstalled" == "0" ]] && [[ "$TEST" == "1" ]]; then
	echo "KO"
    elif [[ "$isInstalled" == "1" ]] && [[ "$TEST" == "1" ]]; then
	echo "OK"
    fi
}

# git result
#
# Args:
#   commit: string: commit id
# Returns:
#   string: git result
function print {
    local commit=$1
    local smart=0
    question
    if [[ "$SMART" == "1" ]]; then
	git log $commit --pretty=oneline -n 1
    else
	if [ -z "$(git log --pretty=oneline | grep $commit | awk '{if ($2~/step/ && $3~/[0-9]/) print $3}')" ]; then
	    smart=1
	fi
	if [[ "$VERBOSE" == "0" ]] && [[ "$smart" == "1" ]]; then
	    git log $commit --pretty=oneline -n 1
	elif [[ "$smart" == "1" ]] || [[ "$VERBOSE" == "0" ]]; then
	    git log $commit --pretty=oneline -n 1 --name-only
	else
	    git log $commit --pretty=oneline -p -1
	fi
    fi
}

# interaction with the client
#
# Args:
#   answer: string: Y or Enter or N
# Returns:
#   mixed: string: question or nothing
function question {
    if [[ "$INTERACTION" == "1" ]]; then
	if [[ "$QUESTION" == "1" ]]; then
	    echo
	    error 'Do you continue [Yn]?'
	fi
	read -s answer
	if [ -n "$answer" ] && [[ ! $answer =~ ^[yY]$ ]]; then
	    exit 1
	fi
    fi
}

# main
## get options of the script
while true; do
    case "$1" in
	-h | --help ) help ;;
	-V | --version ) version; exit 1; ;;
	-t | --test ) TEST=1; gitTest; exit 1; ;;
	-v | --verbose ) VERBOSE=1 ;;
	-c | --commit ) COMMIT="$2"; SMART=1; shift ;;
	-i | --interaction ) INTERACTION=1; QUESTION=1 ;;
	-s | --skip-question ) QUESTION=0 ;;
	-- ) shift; break ;;
	* ) break ;;
    esac
    shift
done

## test if git is installed
gitTest

## run the job
commits=$(git log --pretty=oneline | tac | awk '{print $1}')
for commit in ${commits[@]}; do
    if [[ "$COMMIT" != "0" ]] && [[ $commit =~ $COMMIT ]]; then
	SMART=0
    fi
    print $commit
done
