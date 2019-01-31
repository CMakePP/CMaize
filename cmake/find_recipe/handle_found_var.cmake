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
include(object/object)
include(string/cpp_string_cases)

## Function for processing the ``<Name>_FOUND`` variable of ``find_package``
#
# CMake's ``find_package`` function returns the result via ``<Name>_FOUND``
# variable. While convention is that the capitalization of the package's name
# in the variable matches the capitialization used to call ``find_package``,
# particularly when ``find_package`` is used in "module" mode, this is not
# always the case. This function will loop over possible capitalizations in an
# attempt to better ensure we find the results of ``find_package``.
#
# .. note::
#
#     This function should be considered a protected member function of the
#     FindRecipe class.
#
# :param handle: A handle to the FindRecipe instance we are assessing the
#                found-ness of.
#
# :CMake Variables:
#
#     * *<Name>_FOUND* - Here ``<Name>`` matches the input capitalization. This
#       variable will be considered as one possible output of ``find_package``.
#     * *<NAME>_FOUND* - Here ``<NAME>`` is the name in all uppercase letters.
#       This variable will be considered as one possible output of
#       ``find_package``.
#     * *<name>_FOUND* - Here ``<name>`` is the name in all lowercase letters.
#       This variable will be considered as one possible output of
#       ``find_package``.
function(_cpp_FindRecipe_handle_found_var _cFhfv_handle)
    _cpp_Object_get_value(${_cFhfv_handle} _cFhfv_name name)
    _cpp_string_cases(_cFhfv_cases "${_cFhfv_name}")
    foreach(_cFhfv_var ${_cFhfv_cases})
        if("${${_cFhfv_var}_FOUND}")
            _cpp_Object_set_value(${_cFhfv_handle} found TRUE)
            return()
        endif()
    endforeach()
endfunction()
