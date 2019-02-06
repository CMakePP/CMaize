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
include(logic/is_target)
include(logic/negate)
include(utility/parse_target_name)
include(utility/set_return)

function(_cpp_read_helper_targets _crht_frs _crht_targets)
    foreach(_crht_i ${_crht_targets})
        _cpp_is_target(_crht_is_target ${_crht_i})
        if(_crht_is_target)
            _cpp_parse_target(_crht_i _crht_comp ${_crht_i})
            set(_crht_helper _cpp_${_crht_i}_helper)
            get_target_property(_crht_fr ${_crht_helper} _cpp_object)
            list(APPEND _crht_rv "${_crht_fr}")
        endif()
    endforeach()
    _cpp_set_return(${_crht_frs} "${_crht_rv}")
endfunction()
