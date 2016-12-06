#!/bin/bash

# Copyright 2016 Alessandra Bilardi. All Rights Reserved.
# Released under the MIT License.
# Author: alessandra.bilardi@gmail.com (Alessandra Bilardi)
#
# Unit test.
#
# This script contains the basic test of the see-git-steps.

# initialize
BIN="../see-git-steps.sh"

# main
assertLike "function version -V" "$(./$BIN -V)" "[0-9]+.[0-9]+.[0-9]+"
assertLike "function version --version" "$(./$BIN --version)" "[0-9]+.[0-9]+.[0-9]+"
assertLike "function version -h" "$(./$BIN -h | grep SYNOPSIS)" "SYNOPSIS"
assertLike "function version --help" "$(./$BIN --help | grep SYNOPSIS)" "SYNOPSIS"

assertLike "function getTest -t" "$(./$BIN -t)" "OK"
assertLike "function getTest --test" "$(./$BIN --test)" "OK"

assertLike "check where Initial commit is in the output" "$(./$BIN | head -n 1)" "Initial commit"
assertLike "check where step 2 is in the output" "$(./$BIN | head -n 8 | tail -n 1)" "step 2 -"

assertLike "check where Initial commit with -v option" "$(./$BIN -v | head -n 1)" "Initial commit"
assertLike "check where step 2 with -v option" "$(./$BIN -v | head -n 256 | tail -n 1)" "step 2 -"
assertLike "check where Initial commit with --verbose option" "$(./$BIN --verbose | head -n 1)" "Initial commit"
assertLike "check where step 2 with --verbose option" "$(./$BIN --verbose | head -n 256 | tail -n 1)" "step 2 -"

assertLike "check where Initial commit with -c option" "$(./$BIN -c eed87c9 | head -n 1)" "Initial commit"
assertLike "check where step 2 with -c option" "$(./$BIN -c eed87c9 | head -n 3 | tail -n 1)" "step 2 -"
assertLike "check where Initial commit with --commit option" "$(./$BIN --commit eed87c9 | head -n 1)" "Initial commit"
assertLike "check where step 2 with --commit option" "$(./$BIN --commit eed87c9 | head -n 3 | tail -n 1)" "step 2 -"
