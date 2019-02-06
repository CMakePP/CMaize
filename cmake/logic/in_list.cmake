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

function(_cpp_in_list _cil_return _cil_value _cil_list)
    list(FIND "${_cil_list}" "${_cil_value}" _cil_temp)
    _cpp_are_not_equal(_cil_temp "${_cil_temp}" -1)
    _cpp_set_return(${_cil_return} ${_cil_temp})
endfunction()
