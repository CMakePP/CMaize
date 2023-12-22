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
# Checks if a target with the same name is already added to this project.
# This defaults to build targets.
#
# This internal implementation exists so a required keyword argument is
# not part of the public interface, as well as to handle both ``desc`` and
# ``target`` types. Both types are effectively strings representing target
# names in this algorithm and can be treated equivalently, but cannot be
# typecast to each other by CMakePPLang. The CMakePPLang type checking
# is bypassed through the aforementioned required keyword argument for
# the target name, essentially combining the two types.
#
# :param __ct_found: Return variable for whether the target was found.
# :type __ct_found: bool*
# :param NAME: Required keyword argument. See description below.
# :type NAME: desc or target
# :param **kwargs: Additional keyword arguments may be necessary.
#
# :Keyword Arguments:
#    * **INSTALLED** (*bool*) --
#      Flag to indicate that the installed targets should be checked.
#    * **ALL** (*bool*) --
#      Flag to indicate that both the build and installed targets should
#      be checked.
#    * **NAME** (*desc* or *target*) --
#      Identifying name for a target contained in the current Cmaize
#      project. This keyword argument is **required**.
#
# :returns: CMaizeTarget found (TRUE) or not (FALSE).
# :rtype: bool
#]]
function(_check_target self  __ct_found)

    set(__ct_options INSTALLED ALL)
    set(__ct_one_value_args NAME)
    cmake_parse_arguments(
        __ct "${__ct_options}" "${__ct_one_value_args}" "" ${ARGN}
    )

    # Ensure that NAME was provided
    cpp_contains(
        __ct_name_exists __ct_NAME "${__ct_KEYWORDS_MISSING_VALUES}"
    )
    if(__ct_name_exists)
        cpp_raise(KeywordMissing "Missing required keyword argument: NAME")
    endif()

    # Default to the build target list
    set(__ct_tgt_attr "build_targets")
    if(__ct_ALL)
        # Search both lists
        list(APPEND __ct_tgt_attr "installed_targets")
    elseif(__ct_INSTALLED)
        set(__ct_tgt_attr "installed_targets")
    endif()

    foreach(__ct_tgt_attr_i ${__ct_tgt_attr})
        # Get the collection of targets
        CMaizeProject(GET "${self}" __ct_tgt_map "${__ct_tgt_attr_i}")

        # We check if the key exists here, but that is not sufficient
        # to know if the value is valid if the key exists. It is possible
        # from CMaizeProject(add_target for the key to exist but the value
        # to be blank since we cannot easily remove keys from a map
        cpp_map(HAS_KEY "${__ct_tgt_map}" __ct_key_found_i "${__ct_NAME}")

        # Initially, set whether the key was found and whether the target
        # was found to the same value, but this may change in the check
        # below
        set(__ct_found_i "${__ct_key_found_i}")

        # Check if a target with the same name already exists
        # NOTE: Doesn't work for some reason
        # cpp_map(HAS_KEY "${__ct_tgt_map}" __ct_found_i "${__ct_NAME}")

        # Additional check if the target key exists in the map to ensure
        # that the target actually exists
        if(__ct_key_found_i)
            cpp_map(GET "${__ct_tgt_map}" __ct_key_value_i "${__ct_NAME}")

            cpp_type_of(__ct_key_value_i_type "${__ct_key_value_i}")

            # Check if the value is implicitly convertible to a CMaizeTarget
            cpp_implicitly_convertible(
                __ct_is_target_type "${__ct_key_value_i_type}" CMaizeTarget
            )

            # If it is convertible to a CMaizeTarget, then the target exists
            set(__ct_found_i "${__ct_is_target_type}")

            # Unless it is an empty string
            if("${__ct_key_value_i}" STREQUAL "")
                set(__ct_found_i FALSE)
            endif()
        endif()

        # Return early if target is found
        if(__ct_found_i)
            set("${__ct_found}" "${__ct_found_i}")
            cpp_return("${__ct_found}")
        endif()
    endforeach()

    set("${__ct_found}" FALSE)
    cpp_return("${__ct_found}")

endfunction()
