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
include(utility/set_return)

function(_cpp_read_helper_targets _crht_frs _crht_targets)
    foreach(_crht_target ${_crht_targets})
        get_property(
            _crht_depends
            TARGET ${_crht_target}
            PROPERTY INTERFACE_LINK_LIBRARIES
        )
        foreach(_crht_i ${_crht_depends})
            _cpp_is_target(_crht_is_target ${_crht_i})
            if(_crht_is_target)
                set(_crht_is_bad FALSE)
                #Make sure it's not one of the targets
                foreach(_crht_j ${_crht_targets})
                    _cpp_are_equal(_crht_is_bad "${_crht_i}" "${_crht_j}")
                    if(_crht_is_bad)
                        break()
                    endif()
                endforeach()
                _cpp_negate(_crht_is_good "${_crht_is_bad}")
                if(_crht_is_good)
                    set(_crht_helper _cpp_${_crht_i}_helper)
                    get_property(_crht_fr _crht_helper _cpp_object)
                    list(APPEND _crht_rv "${_crht_fr}")
                endif()
            else()
                _cpp_error("${_crht_i} is not a target")
            endif()
        endforeach()
    endforeach()
    if(_crht_rv)
        list(REMOVE_DUPLICATES _crht_rv)
    endif()
    _cpp_set_return(${_crht_frs} "${_crht_rv}")
endfunction()
