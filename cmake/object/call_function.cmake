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
include(object/impl/mangle_function_name)

## This function does not work, but starts a function for member dispatching.
#
# :param handle: The object whose member function is being called
#
#
function(_cpp_Object_call_function _cOcf_handle _cOcf_prefix _cOcf_fxn)
    #Get a list of types that starts with the most derived and ends with Object
    _cpp_Object_get_value(${_cOcf_handle} _cOcf_types _cpp_type)
    list(REVERSE _cOcf_types)

    #Loop over type list looking for member function file, break when found
    set(_cOcf_inc_file "")
    foreach(_cOcf_type_i ${_cOcf_types})
        _cpp_mangle_function_name(_cOcf_mn ${_cOcf_type_i} ${_cOcf_fxn})
        _cpp_Object_has_member(${_cOcf_handle} _cOcf_has_fxn ${_cOcf_mn})
        if(_cOcf_has_fxn)
            _cpp_Object_get_value(${_cOcf_handle} _cOcf_inc_file ${_cOcf_mn})
            _cpp_Object_get_value(
                ${_cOcf_handle} _cOcf_returns ${_cOcf_mn}_returns
            )
            break()
        endif()
    endforeach()

    #Ensure we found a function
    _cpp_is_empty(_cOcf_no_fxn _cOcm_inc_file)
    if(_cOcf_no_fxn)
        _cpp_error("Class does not have a member function ${_cOcf_fxn}")
    endif()

    #Include and call the function
    include(${_cOcm_inc_file})
    _member_fxn(${_cOcf_handle} ${ARGN})

    #Loop over returns and return them from this function
    foreach(_cOcf_return ${_cOcf_returns})
        _cpp_is_not_defined(_cOcf_not_def ${_cOcf_return})
        if(_cOcf_not_def)
            _cpp_error(
                "Function ${_cOcf_fxn} did not set return ${_cOcf_return}"
            )
        endif()
        _cpp_set_return(${_cOcf_prefix}_${_cOcf_return} "${${_cOcf_return}}")
    endforeach()
endfunction()
