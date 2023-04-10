#!/usr/bin/env bash

# Exit on error
set -x

source "./utilities.sh"

current_datetime=`date +%Y-%m-%d_%H%M%S`

TOKEN=$2
PACKAGE=CMakePrivate
SOURCE=https://$TOKEN@github.com/CMaizeExamples/$PACKAGE.git

BUILD_TYPE=Debug
WORKSPACE=`pwd`
TOOLCHAIN=$WORKSPACE/toolchain.cmake

cmake_cmd=cmake
ctest_cmd=ctest
git_cmd=git

cores=2

if [ "$1" = "--clean" ]; then
    echo "Removing 'src/' and 'install/' directories..."
    rm -rf src install
fi


# Print version information
echo "---------- Version Info ----------"
echo "Command: ${cmake_cmd}"
${cmake_cmd} --version
echo
echo "Command: ${ctest_cmd}"
${ctest_cmd} --version
echo
echo "Command: ${git_cmd}"
${git_cmd} --version
echo "---------- End Version Info ----------"
echo


# ---------- Download/Set up ----------

echo "Making log directory..."
log_dir=$WORKSPACE/logs/$PACKAGE
mkdir -p ${log_dir}

src_dest=$WORKSPACE/src/$PACKAGE
echo "Checking for source code..."

if [ -d "${src_dest}" ]; then
    echo "Source code found. Skipping download."
else
    echo "Source code not found. Downloading..."
    ${git_cmd} clone $SOURCE src/$PACKAGE --progress --verbose \
        2>&1 | tee "${log_dir}/${current_datetime}_clone.log"
fi


# ---------- Build and Test ----------

build_and_install $PACKAGE ${log_dir} $TOOLCHAIN $WORKSPACE/install \
    "Debug" $cores $TOKEN

# Verify that the installation was successful
echo "Verifying package installation..."

check_dir_exists  "install/include/cmake_private"
check_file_exists "install/include/cmake_private/cmake_private.hpp"
check_dir_exists  "install/lib/cmakeprivate"
check_file_exists "install/lib/cmakeprivate/libCMakePrivate.so"
check_dir_exists  "install/lib/cmakeprivate/cmake"
check_file_exists "install/lib/cmakeprivate/cmake/${PACKAGE}Config.cmake"
