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


set -e

# Checks if the given directory exists. Calls "exit 1" if it does not exist,
# crashing the program.
#
# :param $1: Full or relative path to the directory to check.
# :type $1: str
check_dir_exists() {
    local dir=$1

    if [ ! -d "$dir" ]; then
        echo "Directory does not exist: $dir"
        exit 1
    fi

    echo "Directory found: $dir"
}

# Checks if the given file exists. Calls "exit 1" if it does not exist,
# crashing the program.
#
# :param $1: Full or relative path to the file to check.
# :type $1: str
check_file_exists() {
    local filename=$1

    if [ ! -f "$filename" ]; then
        echo "File does not exist: $filename"
        exit 1
    fi

    echo "File found: $filename"
}

# Configures, builds, tests, and installs the given package.
#
# This function is only designed to work with the file structure used
# in the CMaize testing scripts.
#
# :param $1: Package name
# :type $1: str
# :param $2: Full path to the log directory.
# :type $2: str
# :param $3: Full path to toolchain file.
# :type $3: str
# :param $4: Full path to installation prefix.
# :type $4: str
# :param $5: CMake build type, defaults to "Debug".
# :type $5: str, optional
# :param $6: Number of cores to use for the build, defaults to 2.
# :type $6: int, optional
build_and_install() {

    local package=$1
    local log_dir=$2
    local toolchain=$3
    local install_prefix=$4
    local build_type=$5
    local cores=$6
    local token=$7

    if [ "${build_type}" = "" ]; then
        build_type="Debug"
    fi

    if [ "$cores" = "" ]; then
        cores=2
    fi

    local current_datetime=`date +%Y-%m-%d_%H%M%S`

    cd src/$package

    # Create buildsystem
    ${cmake_cmd} \
        -H. \
        -Bbuild \
        -DBUILD_TESTING=ON \
        -DCMAKE_BUILD_TYPE=${build_type} \
        -DCMAKE_TOOLCHAIN_FILE=$toolchain \
        -DCMAKE_INSTALL_PREFIX=${install_prefix} \
        -DCMAIZE_GITHUB_TOKEN=$token \
        2>&1 | tee "${log_dir}/${current_datetime}_gen.log"

    # Perform the build
    ${cmake_cmd} \
        --build build \
        --parallel ${cores} \
        2>&1 | tee "${log_dir}/${current_datetime}_build.log"


    # Run unit tests
    cd build
    ${ctest_cmd} \
        -C ${build_type} \
        --output-on-failure \
        2>&1 | tee "${log_dir}/${current_datetime}_test.log"
    cd ..  # Back out of the build/ directory

    # Install
    ${cmake_cmd} \
        --build build \
        --target install \
        2>&1 | tee "${log_dir}/${current_datetime}_install.log"

    cd ../..  # Back out of the src/$package/ directory
}

export -f build_and_install
export -f check_dir_exists
export -f check_file_exists
