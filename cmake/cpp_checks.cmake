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

#Note: Use False=0 and True=1 not FALSE/OFF/TRUE/ON otherwise if statements
#won't recognize the return's contents as boolean without a CMake policy being
#set.

include(logic/is_defined)
include(logic/is_not_defined)

function(_cpp_is_empty _cie_return _cie_input)
    string(COMPARE EQUAL "${${_cie_input}}" "" _cie_empty)
    set(${_cie_return} ${_cie_empty} PARENT_SCOPE)
endfunction()

function(_cpp_is_not_empty _cne_return _cne_input)
    string(COMPARE NOTEQUAL "${${_cne_input}}" "" _cne_empty)
    set(${_cne_return} ${_cne_empty} PARENT_SCOPE)
endfunction()

function(_cpp_contains _cc_return _cc_substring _cc_string)
    string(FIND "${_cc_string}" "${_cc_substring}" _cc_pos)
    if("${_cc_pos}" STREQUAL "-1")
        set(${_cc_return} 0 PARENT_SCOPE)
    else()
        set(${_cc_return} 1 PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_does_not_contain _cdnc_return _cdnc_substring _cdnc_string)
    string(FIND "${_cdnc_string}" "${_cdnc_substring}" _cdnc_pos)
    if("${_cdnc_pos}" STREQUAL "-1")
        set(${_cdnc_return} 1 PARENT_SCOPE)
    else()
        set(${_cdnc_return} 0 PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_xor _cx_return)
    set(_cx_found_true FALSE)
    foreach(_cx_item ${ARGN})
        if(${_cx_item} AND _cx_found_true)
            set(${_cx_return} FALSE PARENT_SCOPE)
            return()
        elseif(${_cx_item})
            set(_cx_found_true TRUE)
        endif()
    endforeach()
    set(${_cx_return} ${_cx_found_true} PARENT_SCOPE)
endfunction()

include(logic/is_target)
include(logic/is_not_target)
include(logic/negate)


function(_cpp_exists _ce_return _ce_path)
    if(EXISTS ${_ce_path})
        set(${_ce_return} 1 PARENT_SCOPE)
    else()
        set(${_ce_return} 0 PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_does_not_exist _cdne_return _cdne_path)
    if(EXISTS ${_cdne_path})
        set(${_cdne_return} 0 PARENT_SCOPE)
    else()
        set(${_cdne_return} 1 PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_is_directory _cid_return _cid_path)
    if(IS_DIRECTORY ${_cid_path})
        set(${_cid_return} 1 PARENT_SCOPE)
    else()
        set(${_cid_return} 0 PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_is_not_directory _cind_return _cind_path)
    if(IS_DIRECTORY ${_cind_path})
        set(${_cind_return} 0 PARENT_SCOPE)
    else()
        set(${_cind_return} 1 PARENT_SCOPE)
    endif()
endfunction()

include(logic/are_equal)
include(logic/are_not_equal)
include(logic/is_list)
include(logic/is_not_list)

