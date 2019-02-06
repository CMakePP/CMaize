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
include(kwargs/set_kwarg)

## Wraps ``cmake_parse_argn`` and sets ``Kwargs`` object accordingly
#
# This function reads the entire list of possible CMake kwargs from the provided
# ``Kwargs`` instance. It then uses this list to call ``cmake_parse_arguments``
# to parse the non-positional arguments provided to this function. The
# corresponding members of the ``Kwargs`` instance are then updated with the
# values provided in the non-positional arguments. If lists are present, this
# function will only work correctly if all possible CMake kwargs are registered
# with the provided ``Kwargs`` instance.
#
#
# :param handle: The ``Kwargs`` object to populate from the CMake kwargs.
#
# :Example Usage:
#
# .. code-block:: cmake
#
#     function(example_fxn)
#         _cpp_Kwargs_ctor(kwargs)
#         _cpp_Kwargs_add_keywords(${kwargs} TOGGLES A_TOGGLE OPTIONS AN_OPTION)
#         _cpp_Kwargs_parse_argn(${kwargs} ${ARGN})
#         #Do stuff with kwargs
#     endfunction()
#
#     example_fxn(A_TOGGLE AN_OPTION value)
#
#
function(_cpp_kwargs_parse_argn _cKpa_handle)
    _cpp_Object_get_value(${_cKpa_handle} _cKpa_toggles toggles)
    _cpp_Object_get_value(${_cKpa_handle} _cKpa_options options)
    _cpp_Object_get_value(${_cKpa_handle} _cKpa_lists lists)

    cmake_parse_arguments(
        _cKpa "${_cKpa_toggles}" "${_cKpa_options}" "${_cKpa_lists}" ${ARGN}
    )

    #Toggles are False and Options/Lists are empty if not present. This variable
    #will be set to the appropriate not present string for comparison.
    set(_cKpa_not_set_str FALSE)
    foreach(_cKpa_category toggles options lists)
        foreach(_cKpa_option_i ${_cKpa_${_cKpa_category}})
            set(_cKpa_value "${_cKpa_${_cKpa_option_i}}")
            _cpp_are_equal(
                _cKpa_not_set "${_cKpa_value}" "${_cKpa_not_set_str}"
            )
            if(_cKpa_not_set)
                continue()
            endif()
            _cpp_Kwargs_set_kwarg(
                ${_cKpa_handle} ${_cKpa_option_i} "${_cKpa_value}"
            )
        endforeach()
        set(_cKpa_not_set_str "") #Remaining iterations: options and lists
    endforeach()
    _cpp_Object_set_value(
        ${_cKpa_handle} unparsed "${_cKpa_UNPARSED_ARGUMENTS}"
    )
endfunction()
