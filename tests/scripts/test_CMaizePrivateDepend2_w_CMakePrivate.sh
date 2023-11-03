#!/usr/bin/env bash

# Exit on error
set -e

source ./test_CMakePrivate.sh $1 $2
source ./test_CMaizePrivateDepend2.sh "" $2
