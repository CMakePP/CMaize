#!/usr/bin/env bash
# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


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

libext="so"
if [[ "`uname`" == 'Darwin' ]]; then
    libext=dylib
fi

check_dir_exists  "install/include/cmake_public"
check_file_exists "install/include/cmake_public/cmake_public.hpp"
check_dir_exists  "install/lib/CMakePublic"
check_file_exists "install/lib/CMakePublic/libhello.$libext"
check_file_exists "install/lib/CMakePublic/libworld.$libext"
check_dir_exists  "install/lib/CMakePublic/cmake"
check_file_exists "install/lib/CMakePublic/cmake/${PACKAGE}Config.cmake"
check_file_exists "install/lib/CMakePublic/cmake/helloConfig.cmake"
check_file_exists "install/lib/CMakePublic/cmake/worldConfig.cmake"
