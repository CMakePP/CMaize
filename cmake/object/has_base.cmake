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
include(object/get_value)
include(utility/set_return)

## Determines if the object derives from a particular base class
#
# Type dispatching needs to be manually implemented. This is easiest to do if
# there's a function for determining whether an object inherits from a
# particular type or not. This is such a function.
#
# :param handle: A handle to the object whose base is being inquired about.
# :param return: An identifier to hold the result.
# :param base: The type we want to know if handle inherits from.
function(_cpp_Object_has_base _cOhb_handle _cOhb_return _cOhb_base)
    _cpp_Object_get_value(${_cOhb_handle} _cOhb_types _cpp_type)
    list(FIND _cOhb_types ${_cOhb_base} _cOhb_pos)
    _cpp_are_not_equal(_cOhb_has_base "${_cOhb_pos}" "-1")
    _cpp_set_return(${_cOhb_return} ${_cOhb_has_base})
endfunction()
