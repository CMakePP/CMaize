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

include(cpp_checks) #For _cpp_is_not_empty
include(cpp_print) #For _cpp_debug_print
include(options/cpp_parse_arguments)
function(cpp_option _co_opt _co_default)
    _cpp_is_not_empty(_co_valid ${_co_opt})
    if(_co_valid)
        _cpp_debug_print("${_co_opt} set by user to: ${${_co_opt}}")
    else()
        set(${_co_opt} ${_co_default} PARENT_SCOPE)
        _cpp_debug_print("${_co_opt} set to default: ${_co_default}")
    endif()
endfunction()

function(_cpp_pack_list _cpl_return)
    string(REPLACE ";" "\\;" _cpl_argn "${ARGN}")
    _cpp_contains(_cpl_packed "_cpp_0_cpp_" "${_cpl_argn}")
    if(_cpl_packed)
        message(FATAL_ERROR "List is already packed.")
    endif()
    foreach(_cpl_args ${_cpl_argn})
        string(REPLACE ";" "_cpp_0_cpp_" _cpl_args "${_cpl_args}")
        list(APPEND _cpl_list "${_cpl_args}")
    endforeach()
    set(${_cpl_return} "${_cpl_list}" PARENT_SCOPE)
endfunction()

function(_cpp_unpack_list _cul_return _cul_list)
    string(REPLACE "_cpp_0_cpp_"       ";" _cul_list "${_cul_list}")
    set(${_cul_return} "${_cul_list}" PARENT_SCOPE)
endfunction()
