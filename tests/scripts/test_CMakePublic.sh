#!/usr/bin/env bash

# Exit on error
set -e

source "./utilities.sh"

current_datetime=`date +%Y-%m-%d_%H%M%S`

PACKAGE=CMakePublic
SOURCE=https://github.com/CMaizeExamples/$PACKAGE.git

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

log_dir=$WORKSPACE/logs/$PACKAGE
mkdir -p ${log_dir}

src_dest=$WORKSPACE/src/$PACKAGE
echo "Checking for source code..."

if [ -d "${src_dest}" ]; then
    echo "Source code found. Skipping download."
else
    echo "Source code not found. Downloading..."
    ${git_cmd} clone $SOURCE src/$PACKAGE \
        2>&1 | tee "${log_dir}/${current_datetime}_clone.log"
fi


# ---------- Build and Test ----------

build_and_install $PACKAGE ${log_dir} $TOOLCHAIN $WORKSPACE/install \
    "Debug" $cores

# Verify that the installation was successful
echo "Verifying package installation..."

check_dir_exists  "install/include/cmake_public"
check_file_exists "install/include/cmake_public/cmake_public.hpp"
check_dir_exists  "install/lib/CMakePublic"
check_file_exists "install/lib/CMakePublic/libhello.so"
check_file_exists "install/lib/CMakePublic/libworld.so"
check_dir_exists  "install/lib/CMakePublic/cmake"
check_file_exists "install/lib/CMakePublic/cmake/${PACKAGE}Config.cmake"
check_file_exists "install/lib/CMakePublic/cmake/helloConfig.cmake"
check_file_exists "install/lib/CMakePublic/cmake/worldConfig.cmake"
