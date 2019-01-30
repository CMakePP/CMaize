################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()

## Function that wraps searching for a dependency using "special" variables.
#
# For a dependency, ``<Name>``, CMake reserves two variables: ``<Name>_DIR`` and
# ``<Name>_ROOT``. The former is used to tell CMake what directory the config
# files are in. The latter is used to tell CMake the root of the package's
# install tree. Particularly with respect to the latter, this provides a
# straightforward means for the user to force CMake to use a particular version
# of a package, *i.e.*, point ``<Name>_ROOT`` at the version you want CMake to
# use. This function uses CPP's find-recipes and attempts to honor any of these
# variables, if set. Additionally, this function loosens the case restrictions
# on the variable by honoring additonal capitalizations such as all lowercase
# and all uppercase.
#
# :param found: The identifier to hold the result. Will be set to TRUE if the
#     dependency was found and false otherwise.
# :param name: The name of the dependency we are looking for.
# :param recipe: The path to the find-recipe to use.
# :param version: The version of the dependency we are looking for.
# :param comps: A list of the dependency's components we require.
#
# :CMake Variables:
#
#     * *<Name>_DIR* - Used as a potential source of paths for the package's
#       config files. Uses input capitialization.
#     * *<Name>_ROOT* - Used as a potential source of paths for the package's
#       install directory. Uses input capitialization.
#     * *<name>_DIR* - Used as a potential source of paths for the package's
#       config files. Uses the name in all lowercase.
#     * *<name>_ROOT* - Used as a potential source of paths for the package's
#       install directory. Uses the name in all lowercase.
#     * *<NAME>_DIR* - Used as a potential source of paths for the package's
#       config files. Uses the name in all uppercase.
#     * *<NAME>_ROOT* - Used as a potential source of paths for the package's
#       install directory. Uses the name in all uppercase.
function(_cpp_special_find _csf_found _csf_name _csf_recipe _csf_version
                           _csf_comps)
    include(${_csf_recipe})
    string(TOUPPER "${_csf_name}" _csf_uc_name)
    string(TOLOWER "${_csf_name}" _csf_lc_name)
    set(_csf_was_found FALSE)
    foreach(_csf_case ${_csf_name} ${_csf_uc_name} ${_csf_lc_name})
        foreach(_csf_suffix _DIR _ROOT)
            set(_csf_var ${_csf_case}${_csf_suffix})
            #Did the user set this variable
            _cpp_is_not_empty(_csf_set ${_csf_var})
            if(_csf_set)
                set(_csf_value ${${_csf_var}})
                _cpp_debug_print(
                    "Looking for ${_csf_name} with ${_csf_var}=${_csf_value}"
                )
                _cpp_find_recipe(
                    _csf_was_found
                    "${_csf_version}"
                    "${_csf_comps}"
                    "${_csf_value}"
                )
                if(NOT _csf_was_found)
                    _cpp_error(
                        "Variable ${_csf_var} set to ${_csf_value}, but "
                        "${_csf_name} was not found there."
                    )
                endif()
                break()
            endif()
        endforeach()
        if(_csf_was_found)
            break()
        endif()
    endforeach()
    set(${_csf_found} ${_csf_was_found} PARENT_SCOPE)
endfunction()

