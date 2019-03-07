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
#
#
function(_cpp_Function_run _cFr_handle _cFr_prefix)
    _cpp_Object_get_value(${_cFr_handle} _cFr_this this)
    _cpp_Object_get_value(${_cFr_handle} _cFr_returns returns)
    _cpp_Object_get_value(${_cFr_handle} _cFr_file file)
    _cpp_Object_get_value(${_cFr_handle} _cFr_kwargs kwargs)

    #---------------------------------------------------------------------------
    #-----------------------Assemble positional arguments-----------------------
    #---------------------------------------------------------------------------

    _cpp_is_not_empty(_cFr_has_kwargs _cFr_kwargs)
    _cpp_is_not_empty(_cFr_has_return _cFr_returns)
    set(_cFr_args)
    _cpp_is_not_empty(_cFr_is_member _cFr_this)
    if(_cFr_is_member)
        set(_cFr_args ${_cFr_this})
    endif()
    if(_cFr_has_return)
        _cpp_is_empty(_cFr_no_prefix _cFr_prefix)
        if(_cFr_no_prefix)
            _cpp_error("Prefix can not be empty for functions with returns.")
        endif()
        list(APPEND _cFr_args ${_cFr_prefix})
    endif()
    if(_cFr_has_kwargs)
        _cpp_kwargs_parse_argn(${_cFr_kwargs} ${ARGN})
        list(APPEND _cFr_args ${_cFr_kwargs})
    else()
        list(APPEND _cFr_args ${ARGN})
    endif()

    #---------------------------------------------------------------------------
    #-----------------------Call the function-----------------------------------
    #---------------------------------------------------------------------------
    include(${_cFr_file})
    _cpp_fxn(${_cFr_args})

    #---------------------------------------------------------------------------
    #---------------------Forward the returns-----------------------------------
    #---------------------------------------------------------------------------
    foreach(_cFr_return_i ${_cFr_returns})
        set(_cFr_var ${_cFr_prefix}_${_cFr_return_i})
        _cpp_is_not_defined(_cFr_no_return ${_cFr_var})
        if(_cFr_no_return)
            _cpp_error("Function did not set return ${_cFr_return_i}")
        endif()
        _cpp_set_return(${_cFr_var} "${${_cFr_var}}")
    endforeach()
endfunction()
