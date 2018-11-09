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

function(cpp_option _co_opt _co_default)
    _cpp_is_not_empty(_co_valid ${_co_opt})
    if(_co_valid)
        _cpp_debug_print("${_co_opt} set by user to: ${${_co_opt}}")
    else()
        set(${_co_opt} ${_co_default} PARENT_SCOPE)
        _cpp_debug_print("${_co_opt} set to default: ${_co_default}")
    endif()
endfunction()

function(cpp_parse_arguments _cpa_prefix _cpa_argn)
    set(_cpa_M_kwargs TOGGLES OPTIONS LISTS MUST_SET)
#    #Ensure that our keywords don't appear more than once
#    foreach(_cpa_option_i ${_cpa_M_kwargs})
#        string(REGEX MATCHALL "${_cpa_option_i}" _cpa_matches "${ARGN}")
#        list(LENGTH _cpa_matches _cpa_n)
#        if(_cpa_n GREATER 1)
#            _cpp_error("Keyword ${_cpa_option_i} passed ${_cpa_n} times")
#        endif()
#    endforeach()

    #Get the keywords the user wants us to parse
    cmake_parse_arguments(_cpa "" "" "${_cpa_M_kwargs}" "${ARGN}")

#    message("${_cpa_argn}")
#    #Ensure that the user's keywords don't appear more than once
#    foreach(_cpa_option_i ${_cpa_TOGGLES} ${_cpa_OPTIONS} ${_cpa_LISTS})
#        string(REGEX MATCHALL "${_cpa_option_i}" _cpa_matches "${_cpa_argn}")
#        list(LENGTH _cpa_matches _cpa_n)
#        if(_cpa_n GREATER 1)
#            _cpp_error("Keyword ${_cpa_option_i} passed ${_cpa_n} times")
#        endif()
#    endforeach()

    cmake_parse_arguments(
        ${_cpa_prefix}
        "${_cpa_TOGGLES}"
        "${_cpa_OPTIONS}"
        "${_cpa_LISTS}"
        "${_cpa_argn}"
    )


    #Ensure the values of the options are set
#    foreach(_cpa_option_i ${_cpa_OPTIONS})
#        _cpp_is_empty(_cpa_empty_option ${_cpa_prefix}_${_cpa_option_i})
#        _cpp_contains(_cpa_passed "${_cpa_option_i}" "${_cpa_argn}")
#        if(_cpa_empty_option AND _cpa_passed)
#            message(FATAL_ERROR "OPTION: ${_cpa_option_i} is empty.")
#        endif()
#    endforeach()

    #Ensure required variables are set
    foreach(_cpa_option_i ${_cpa_MUST_SET})
        set(_cpa_var ${_cpa_prefix}_${_cpa_option_i})
        _cpp_is_empty(_cpa_not_set ${_cpa_var})
        if(_cpa_not_set)
            message(FATAL_ERROR "Required option ${_cpa_var} is not set")
        endif()
    endforeach()

    #Forward the results
    foreach(_cpa_category TOGGLES OPTIONS LISTS)
        foreach(_cpa_option_i ${_cpa_${_cpa_category}})
            set(_cpa_var ${_cpa_prefix}_${_cpa_option_i})
            set(${_cpa_var} "${${_cpa_var}}" PARENT_SCOPE)
        endforeach()
    endforeach()
    set(
        ${_cpa_prefix}_UNPARSED_ARGUMENTS
        ${${_cpa_prefix}_UNPARSED_ARGUMENTS}
        PARENT_SCOPE
    )
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
