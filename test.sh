#!/bin/bash

. tap-functions
plan_no_plan

is "$(./test_argparse -f --path=/path/to/file a 2>&1)" 'force: 1
path: /path/to/file
argc: 1
argv[0]: a'

is "$(./test_argparse -f -f --force --no-force 2>&1)" 'force: 2'

is "$(./test_argparse -i 2>&1)" 'error: option `-i` requires a value'

is "$(./test_argparse -i 2 2>&1)" 'int_num: 2'

is "$(./test_argparse -i2 2>&1)" 'int_num: 2'

is "$(./test_argparse -ia 2>&1)" 'error: option `-i` expects an integer value'

is "$(./test_argparse -i 0xFFFFFFFFFFFFFFFFF 2>&1)" \
   'error: option `-i` Numerical result out of range'

is "$(./test_argparse -u 4294967295 2>&1)" 'uint_num: 4294967295'

is "$(./test_argparse -u 4294967296 2>&1)" 'error: option `-u` Numerical result out of range'

is "$(./test_argparse -u -1 2>&1)" 'error: option `-u` Numerical result out of range'

is "$(./test_argparse --ulong 18446744073709551615 2>&1)" 'ulong_num: 18446744073709551615'

is "$(./test_argparse --ulong -1 2>&1)" 'error: option `--ulong` Numerical result out of range'

is "$(./test_argparse -s 2.4 2>&1)" 'flt_num: 2.4'

is "$(./test_argparse -s2.4 2>&1)" 'flt_num: 2.4'

is "$(./test_argparse -sa 2>&1)" 'error: option `-s` expects a numerical value'

is "$(./test_argparse -s 1e999 2>&1)" \
   'error: option `-s` Numerical result out of range'

is "$(./test_argparse -f -- do -f -h 2>&1)" 'force: 1
argc: 3
argv[0]: do
argv[1]: -f
argv[2]: -h'

is "$(./test_argparse -tf 2>&1)" 'force: 1
test: 1'

is "$(./test_argparse --read --write 2>&1)" 'perms: 3'

help_usage='Usage: test_argparse [options] [[--] args]
   or: test_argparse [options]

A brief description of what the program does and how it works.

    -h, --help            show this help message and exit

Basic options
    -f, --force           force to do
    -t, --test            test only
    -p, --path=<str>      path to read
    -i, --int=<int>       selected integer
    -u, --uint=<int>      selected unsigned integer
    --ulong=<int>         selected unsigned long integer
    -s, --float=<flt>     selected float

Bits options
    --read                read perm
    --write               write perm
    --exec                exec perm

Additional description of the program after the description of the arguments.'

is "$(./test_argparse -h)" "$help_usage"

is "$(./test_argparse --help)" "$help_usage"

is "$(./test_argparse --no-help 2>&1)" 'error: unknown option `--no-help`'$'\n'"$help_usage"
