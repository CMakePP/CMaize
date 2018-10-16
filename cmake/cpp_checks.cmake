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

# Functions for testing the state of a variable

#Note: Use False=0 and True=1 not FALSE/OFF/TRUE/ON otherwise if statements
#won't recognize the return's contents as boolean without a CMake policy being
#set.

function(_cpp_is_defined _cid_return _cid_input)
    if(DEFINED ${_cid_input})
        set(${_cid_return} 1 PARENT_SCOPE)
    else()
        set(${_cid_return} 0 PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_is_not_defined _cind_return _cind_input)
    if(DEFINED ${_cind_input})
        set(${_cind_return} 0 PARENT_SCOPE)
    else()
        set(${_cind_return} 1 PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_is_empty _cie_return _cie_input)
    string(COMPARE EQUAL "${${_cie_input}}" "" _cie_empty)
    set(${_cie_return} ${_cie_empty} PARENT_SCOPE)
endfunction()

function(_cpp_non_empty _cne_return _cne_input)
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


function(_cpp_assert_cpp_main_called)
    foreach(_cacmc_var CPP_SRC_DIR CPP_project_name CPP_LIBDIR CPP_BINDIR
                       CPP_INCDIR CPP_SHAREDIR)
        _cpp_valid(_cacmc_valid ${_cacmc_var})
        if(NOT ${_cacmc_valid})
            message(
                FATAL_ERROR
                "${_cacmc_var} is not set.  Did you call CPPMain()?"
            )
        endif()
    endforeach()
endfunction()
