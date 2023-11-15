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

cmake_minimum_required(VERSION 3.11) # For FetchContent
project(test_minimum_with_fetch_content)

get_filename_component(
    FETCHCONTENT_SOURCE_DIR_HELLO_WORLD ${CMAKE_CURRENT_SOURCE_DIR} DIRECTORY
)

# The caller will use a local copy of hello_world's source.
include(FetchContent)
FetchContent_Declare(hello_world)
FetchContent_MakeAvailable(hello_world)

# The below lines of code are used in unit testing this code example
include(CTest)
enable_testing()

add_test(
    NAME "hello_world_via_FetchContent"
    COMMAND hello_world
)
