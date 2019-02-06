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
include(logic/in_list)
include(logic/negate)
include(utility/set_return)

function(_cpp_not_in_list _cnil_return _cnil_value _cnil_list)
    _cpp_in_list(_cnil_temp "${_cnil_value}" "${_cnil_list}")
    _cpp_negate(_cnil_temp "${_cnil_temp}")
    _cpp_set_return(${_cnil_return} ${_cnil_temp})
endfunction()
