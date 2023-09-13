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

#[[[ Ensures that the specified dependency's target exists.
#
# This function will assert that the build or find target exists. If the target
# does not exist this function will raise an informative error.
#
# :param _dct_name: The Dependency we are handling
# :type _dct_name: Dependency
# :param _dct_type: Either "build" or "find" depending on whether we are
#                   building or finding the dependency.
# :type _cft_target: desc
#]]
function(_cpp_dependency_check_target _dct_this _dct_type)

    Dependency(GET "${_dct_this}" _dct_target "${_dct_type}_target")
    if(TARGET "${_dct_target}")
        Dependency(SET "${_dct_this}" target "${_dct_target}")
        return()
    endif()

    Dependency(GET "${_dct_this}" _dct_name name)

    set(_dct_msg "Target ${_dct_target} does not exist. Please ensure that ")
    string(APPEND _dct_msg " BUILD_TARGET is set to the name of the target set")
    string(APPEND _dct_msg " in the add_library/add_executable command and ")
    string(APPEND _dct_msg "that FIND_TARGET is set to the name of the target ")
    string(APPEND _dct_msg "set in ${_dct_name}Config.cmake.")

    message(FATAL_ERROR "${_dct_msg}")
endfunction()
