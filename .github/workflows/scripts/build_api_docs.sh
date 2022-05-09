#!/usr/bin/env bash

# Exit on error
set -e

# Start with a clean slate
rm -rf docs/build
rm -rf build/api_docs
rm -rf docs/src/api/developer

# Create a build directory for the api docs to be generated in
mkdir -p build

# Build the API docs with CMinx
cminx "cmake/cmaize" -o "build/api_docs/cmaize" -r -p cmaize
cminx "cmake/cpp" -o "build/api_docs/cpp" -r -p cpp

# Move the api docs to the documentation directory
mv build/api_docs docs/src/api/developer
