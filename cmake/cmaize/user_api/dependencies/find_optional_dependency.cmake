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

include(cmaize/user_api/dependencies/impl_/check_optional_flag)

function(cmaize_find_optional_dependency _cfod_name _cfod_flag)

    # N.B. ${_cfod_flag} is the variable serving as the flag and
    # ${${_cfod_flag}} is its value

    _check_optional_flag("${_cfod_flag}")

    if("${${_cfod_flag}}")
        find_dependency("${_cfod_name}" ${ARGN})
    elseif(NOT TARGET "${_cfod_name}")
        add_library("${_cfod_name}" INTERFACE)
    endif()

endfunction()
