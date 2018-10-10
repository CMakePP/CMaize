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

include(cpp_checks) #For _cpp_non_empty
include(cpp_print) #For _cpp_debug_print

function(cpp_option _cpo_opt _cpo_default)
    _cpp_non_empty(_cpo_valid ${_cpo_opt})
    if(_cpo_valid)
        _cpp_debug_print("${_cpo_opt} set by user to: ${${_cpo_opt}}")
    else()
        set(${_cpo_opt} ${_cpo_default} PARENT_SCOPE)
        _cpp_debug_print("${_cpo_opt} set to default: ${_cpo_default}")
    endif()
endfunction()
