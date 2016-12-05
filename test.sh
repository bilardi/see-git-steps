#!/bin/bash

# Copyright 2016 Alessandra Bilardi. All Rights Reserved.
# Released under the MIT License.
# Author: alessandra.bilardi@gmail.com (Alessandra Bilardi)
#
# Bash prototype.
#
# This script contains the main functions for getting options and running something

# initialize
VERSION="1.1.2"

# functions

# The script version
#
# Returns:
#   string: version number
function version {
    echo MyScript $VERSION
}

# The script help
#
# Returns:
#   string: script manual
function help {
    cat <<EOF
my-script.sh(1) -- Test library
=================================

## SYNOPSIS

\`my-script.sh\` [-hV]

## OPTIONS

  \`-h, --help\`              display this message

  \`-V, --version\`           output version

  \`-f, --functional-tests\`  run test with test bash units

  \`-i, --integrations\`      load the test bash units

## USAGE

    ./my-script.sh -i

Load into test directory the test bash units.

    ./my-script.sh -f

Run the test bash units.

## AUTHOR

  Alessandra Bilardi <alessandra.bilardi@gmail.com>

## REPORTING BUGS

  https://github.com/bilardi/bash-prototype/issues

## SEE ALSO

  \`test\`(1)

## LICENSE

  MIT (C) Copyright Alessandra Bilardi 2016

EOF
    exit 1
}

# Run test units
#
# Returns:
#   string: test results
function functionalTests {
    integrations
    # todo: to use directory and not single file
    cd test
    echo "Test with Sharness"
    bash sharness.test/functional.sh
    echo "Test with BashUnit"
    bash bashunit.sh -t bashunit.test/functional.sh
    cd ..
}

# Load test units
#
# Returns:
#   string: feedback
function integrations {
    cd test
    if [ ! -d sharness ]; then
	echo "Load Sharness"
	git clone https://github.com/mlafeldt/Sharness.git sharness
	ln -s sharness/sharness.sh sharness.sh
	ln -s sharness/test/Makefile Makefile
	ln -s sharness/aggregate-results.sh aggregate-results.sh
    else
	echo "Sharness is already installed"
    fi
    if [ ! -d bashunit ]; then
	echo "Load BashUnit"
	git clone https://github.com/bilardi/bashunit bashunit
	ln -s bashunit/bashunit.sh bashunit.sh
    else
	echo "BashUnit is already installed"
    fi
    cd ..
}

# main
if [ -z $1 ]; then
    help
fi

## get options of the script
while true; do
    case "$1" in
	-h | --help ) help ;;
	-V | --version ) version; exit 1 ;;
	-f | --functional-tests ) functionalTests ;;
	-i | --integrations ) integrations ;;
	-- ) shift; break ;;
	* ) break ;;
    esac
    shift
done
