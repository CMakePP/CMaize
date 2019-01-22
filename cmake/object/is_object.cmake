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
include(logic/is_not_target)
include(target/target_has_property)
include(logic/negate)
include(object/mangle_member)

## Determines if the input is a handle to a valid CPP object
#
# All CPP objects inherit from the ``Object`` base class. This function simply
# ensures that there is a target corresponding to that
#
# :param return: The identifier to assign the result to.
# :param input: The thing to consider for being a handle to an object
function(_cpp_is_object _cio_return _cio_input)
    _cpp_is_not_target(_cio_is_not_target ${_cio_input})
    if(_cio_is_not_target)
        set(${_cio_return} 0 PARENT_SCOPE)
        return()
    endif()
    foreach(_cio_member_i _cpp_member_list)
        _cpp_Object_mangle_member(_cio_temp ${_cio_member_i})
        _cpp_target_has_property(_cio_no_member ${_cio_input} ${_cio_temp})
        _cpp_negate(_cio_no_member ${_cio_no_member})
        if(_cio_no_member)
            set(${_cio_return} 0 PARENT_SCOPE)
            return()
        endif()
    endforeach()
    set(${_cio_return} 1 PARENT_SCOPE)
endfunction()
