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
include(object/object)
include(utility/set_return)

## Class for holding the user-provided kwargs
#
# :members:
#
#    * toggles  - List of keywords that take no arguments
#    * options  - List of keywords taking one argument
#    * lists    - List of keywords taking one or more arguments
#    * unparsed - The contents of ``ARGN`` that were not parsed
function(_cpp_Kwargs_ctor _cKpa_handle)
    _cpp_Object_ctor(_cKpa_temp)
    _cpp_Object_set_type(${_cKpa_temp} Kwargs)
    _cpp_Object_add_members(${_cKpa_temp} toggles options lists unparsed)
    _cpp_set_return("${_cKpa_handle}" "${_cKpa_temp}")
endfunction()
