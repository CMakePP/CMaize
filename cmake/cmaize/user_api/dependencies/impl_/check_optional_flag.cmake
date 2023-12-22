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

include(cmakepp_lang/cmakepp_lang)

#[[[
# Code factorization for checking that a user passed the name of a flag.
#
# The various ``optional_dependency`` functions are tied to a configuration flag
# which determines whether the option is enabled or not. Users need to provide
# those functions with the name of the flag, NOT its value. This function wraps
# the error-checking logic for ensuring that users passed the value.
#
# :param flag: Name of the option variable.
# :type flag: desc
#
# :raises RUNTIME_ERROR: If ``flag`` is not the name of a variable. In
#    particular we check for empty strings and truth-y/false-y values.
#
#]]
function(_check_optional_flag _cof_flag)

    cpp_type_of(_cof_type "${_cof_flag}")

    if("${_cof_flag}" STREQUAL "")
        cpp_raise(
            RUNTIME_ERROR
            "Expected variable serving as the flag, received an empty string"
        )
    elseif("${_cof_type}" STREQUAL "bool")
        cpp_raise(
            RUNTIME_ERROR
            "Expected variable serving as the flag, received boolean value."
        )
    endif()

endfunction()
