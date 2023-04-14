#!/usr/bin/env bash

# Exit on error
set -e

echo "pwd = `pwd`"
echo "ls = `ls`"

source "`pwd`/test_CMakePrivate.sh $1 $2"
source "`pwd`/test_CMaizePrivateDepend.sh $1 $2"
source "`pwd`/test_CMaizePrivateDepend2.sh $1 $2"
