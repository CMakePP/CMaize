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

include_guard()

if("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
    set(_msg "The build directory (${CMAKE_BINARY_DIR}) is the same as the ")
    string(APPEND _msg "current source directory (${CMAKE_CURRENT_SOURCE_DIR})")
    string(APPEND _msg ". This usually means you are attempting to build in ")
    string(APPEND _msg "source, which is strongly discouraged. Please rerun ")
    string(APPEND _msg "cmake with a build directory (use the -B flag) and ")
    string(APPEND _msg "delete ${CMAKE_CURRENT_SOURCE_DIR}/CMakeCache.txt ")
    string(APPEND _msg "which was created when you ran cmake in source.")
    message(FATAL_ERROR "${_msg}")
endif()

# Issue #100
if(NOT CMAKE_MAXIMUM_RECURSION_DEPTH)
    set(CMAKE_MAXIMUM_RECURSION_DEPTH 2000)
endif()

include(cmaize/globals)
include(cmaize/package_managers/package_managers)
include(cmaize/project/projects)
include(cmaize/targets/targets)
include(cmaize/toolchain/toolchain)
include(cmaize/user_api/user_api)
include(cmaize/utilities/utilities)
