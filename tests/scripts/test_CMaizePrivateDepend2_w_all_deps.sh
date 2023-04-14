#!/usr/bin/env bash

# Exit on error
set -e

echo "pwd = `pwd`"
echo "ls = `ls`"

source "./test_CMakePrivate.sh $1 $2"
source "./test_CMaizePrivateDepend.sh $1 $2"
source "./test_CMaizePrivateDepend2.sh $1 $2"
