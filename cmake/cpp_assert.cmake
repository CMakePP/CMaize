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

function(_cpp_assert_true)
    foreach(_cat_variable ${ARGN})
        if(${_cat_variable})
        else()
            message(
                FATAL_ERROR
                "${_cat_variable} is set to false value: ${${_cat_variable}}"
            )
        endif()
    endforeach()
endfunction()

function(_cpp_assert_false)
    foreach(_caf_variable ${ARGN})
        if(${_caf_variable})
            message(
                FATAL_ERROR
                "${_caf_variable} is set true value: ${${_caf_variable}}"
            )
        endif()
    endforeach()
endfunction()

function(_cpp_assert_equal _cae_lhs _cae_rhs)
    string(COMPARE NOTEQUAL "${_cae_lhs}" "${_cae_rhs}" _cae_result)
    if(_cae_result)
        message(
            FATAL_ERROR
            "LHS != RHS\nLHS : ${_cae_lhs}\nRHS : ${_cae_rhs}"
        )
    endif()
endfunction()

function(_cpp_assert_not_equal _cane_lhs _cane_rhs)
    string(COMPARE EQUAL "${_cane_lhs}" "${_cane_rhs}" _cane_result)
    if(_cane_result)
        message(
            FATAL_ERROR
            "LHS == RHS\nLHS : ${_cane_lhs}\nRHS : ${_cane_rhs}"
        )
    endif()
endfunction()

function(_cpp_assert_exists _cae_path)
    if(EXISTS ${_cae_path})
    else()
        message(
            FATAL_ERROR
            "No such file or directory: ${_cae_path}"
        )
    endif()
endfunction()

function(_cpp_assert_does_not_exist _cadne_path)
    if(EXISTS ${_cadne_path})
        message(
            FATAL_ERROR
            "File or directory exists: ${_cadne_path}"
        )
    endif()
endfunction()

function(_cpp_assert_contains _cac_substring _cac_string)
    string(FIND "${_cac_string}" "${_cac_substring}" _cac_result)
    if("${_cac_result}" STREQUAL "-1")
        set(_cac_msg "Substring \"${_cac_substring}\" not contained in string")
        message(FATAL_ERROR "${_cac_msg} \"${_cac_string}\"")
    endif()
endfunction()

function(_cpp_assert_does_not_contain _cadnc_substring _cadnc_string)
    string(FIND "${_cadnc_string}" "${_cadnc_substring}" _cadnc_result)
    _cpp_assert_equal("${_cadnc_result}" "-1")
endfunction()

function(_cpp_assert_file_contains _cafc_substring _cafc_file)
    file(READ ${_cafc_file} _cafc_contents)
    _cpp_assert_contains("${_cafc_substring}" "${_cafc_contents}")
endfunction()

function(_cpp_assert_file_does_not_contain _cafdnc_substring _cafdnc_file)
    file(READ ${_cafdnc_file} _cafdnc_contents)
    _cpp_assert_does_not_contain("${_cafdnc_substring}" "${_cafdnc_contents}")
endfunction()
