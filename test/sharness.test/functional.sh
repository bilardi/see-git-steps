#!/bin/bash

# Copyright 2016 Alessandra Bilardi. All Rights Reserved.
# Released under the MIT License.
# Author: alessandra.bilardi@gmail.com (Alessandra Bilardi)
#
# Unit test.
#
# This script contains the basic test of the see-git-steps.

# initialize
path=$(pwd)
BIN="$path/../see-git-steps.sh"

# main
test_description="Show basic test units for see-git-steps"

. $path/sharness.sh

test_expect_success "function version -V" "
    $BIN -V | egrep -e '[0-9]+.[0-9]+.[0-9]+'
"

test_expect_success "function version --version" "
    $BIN --version | egrep -e '[0-9]+.[0-9]+.[0-9]+'
"

test_expect_success "function version -h" "
    $BIN -h | grep 'SYNOPSIS'
"

test_expect_success "function version --help" "
    $BIN --help | grep 'SYNOPSIS'
"

test_expect_success "function version -t" "
    $BIN -t | grep 'OK'
"

test_expect_success "function version --test" "
    $BIN --test | grep 'OK'
"

test_expect_success "check where Initial commit is in the output" "
    $BIN | head -n 1 | grep 'Initial commit'
"

test_expect_success "check where step 2 is in the output" "
    $BIN | head -n 8 | tail -n 1 | grep 'step 2 -'
"

test_expect_success "check where Initial commit with -v option" "
    $BIN -v | head -n 1 | grep 'Initial commit'
"

test_expect_success "check where step 2 with -v option" "
    $BIN -v | head -n 256 | tail -n 1 | grep 'step 2 -'
"

test_expect_success "check where Initial commit with --verbose option" "
    $BIN --verbose | head -n 1 | grep 'Initial commit'
"

test_expect_success "check where step 2 with --verbose option" "
    $BIN --verbose | head -n 256 | tail -n 1 | grep 'step 2 -'
"

test_expect_success "check where Initial commit with -c option" "
    $BIN -c eed87c9 | head -n 1 | grep 'Initial commit'
"

test_expect_success "check where step 2 with -c option" "
    $BIN -c eed87c9 | head -n 3 | tail -n 1 | grep 'step 2 -'
"

test_expect_success "check where Initial commit with --commit option" "
    $BIN --commit eed87c9 | head -n 1 | grep 'Initial commit'
"

test_expect_success "check where step 2 with --commit option" "
    $BIN --commit eed87c9 | head -n 3 | tail -n 1 | grep 'step 2 -'
"

test_done
