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

#[[[
# Add a target to the project. Duplicate objects will not be added.
#
# This internal implementation exists so a required keyword argument is
# not part of the public interface, as well as to handle both ``desc`` and
# ``target`` types. Both types are effectively strings representing target
# names in this algorithm and can be treated equivalently, but cannot be
# typecast to each other by CMakePPLang. The CMakePPLang type checking
# is bypassed through the aforementioned required keyword argument for
# the target name, essentially combining the two types.
#
# :param __at_target: CMaizeTarget object to be added.
# :type __at_target: CMaizeTarget
# :param NAME: Required keyword argument. See description below.
# :type NAME: desc or target
# :param **kwargs: Additional keyword arguments may be necessary.
#
# :Keyword Arguments:
#    * **INSTALLED** (*bool*) --
#      Flag to indicate that the target being added is already installed
#      on the system.
#    * **NAME** (*desc* or *target*) --
#      Identifying name for the target. This can match name of either the
#      CMake target or CMaizeTarget object, but is required to do match
#      them. This keyword argument is **required**.
#]]
function(_add_target self __at_target)

    set(__at_options INSTALLED OVERWRITE)
    set(__at_one_value_args NAME)
    cmake_parse_arguments(
        __at "${__at_options}" "${__at_one_value_args}" "" ${ARGN}
    )

    # Ensure that NAME was provided
    cpp_contains(__at_name_exists __at_NAME "${__at_KEYWORDS_MISSING_VALUES}")
    if(__at_name_exists)
        cpp_raise(KeywordMissing "Missing required keyword argument: NAME")
    endif()

    # Default to the build target list
    set(__at_tgt_attr "build_targets")
    if(__at_INSTALLED)
        set(__at_tgt_attr "installed_targets")
    endif()

    # Check if a CMaizeTarget with the same name exists already as either
    # a build or installed target
    CMaizeProject(check_target "${self}" __at_found "${__at_NAME}" ALL)

    # Determine what to do if a target in the project al
    if(__at_found)
        # Exit early if a target with the same name already exists
        if(NOT __at_OVERWRITE)
            cpp_return("")
        endif()

        CMaizeProject(check_target "${self}" __at_build "${__at_NAME}")
        CMaizeProject(
            check_target "${self}" __at_install "${__at_NAME}" INSTALLED
        )

        if(__at_build)
            CMaizeProject(GET "${self}" __at_tgt_map "build_targets")

            # We cannot easily remove a key from a map, so the best option
            # is to just clear the value
            cpp_map(SET "${__at_tgt_map}" "${__at_NAME}" "")
        endif()

        if (__at_install)
            CMaizeProject(GET "${self}" __at_tgt_map "installed_targets")

            cpp_map(SET "${__at_tgt_map}" "${__at_NAME}" "")
        endif()
    endif()

    # Add the target to the map
    CMaizeProject(GET "${self}" __at_tgt_map "${__at_tgt_attr}")

    cpp_map(SET "${__at_tgt_map}" "${__at_NAME}" "${__at_target}")

endfunction()
