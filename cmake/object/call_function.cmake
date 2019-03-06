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
include(function/run)
include(object/get_value)
include(object/impl/mangle_function_name)
include(utility/set_return)

##
#
# :param handle: The object whose member function is being called
#
#
function(_cpp_Object_call _cOc_handle _cOc_prefix _cOc_fxn)
    _cpp_is_empty(_cOc_empty_name _cOc_fxn)
    if(_cOc_empty_name)
        _cpp_error("Function name can't be empty.")
    endif()

    _cpp_mangle_function_name(_cOc_mn "" "${_cOc_fxn}")
    _cpp_Object_get_value(${_cOc_handle} _cOc_vtable ${_cOc_mn})
    list(GET _cOc_vtable -1 _cOc_fxn_ptr)
    _cpp_Object_get_value(${_cOc_handle} _cOc_fxn_obj ${_cOc_fxn_ptr})

    _cpp_Function_run(${_cOc_fxn_obj} "${_cOc_prefix}" ${ARGN})

    #---------------------------------------------------------------------------
    #---------------------------Forward the returns-----------------------------
    #---------------------------------------------------------------------------
    _cpp_Object_get_value(${_cOc_fxn_obj} _cOc_returns returns)
    foreach(_cOc_return ${_cOc_returns})
        set(_cOc_var ${_cOc_prefix}_${_cOc_return})
        _cpp_set_return(${_cOc_var} "${${_cOc_var}}")
    endforeach()
endfunction()
