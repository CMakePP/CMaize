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
include(object/set_value)

function(_cpp_Kwargs_set_kwarg _cKsk_handle _cKsk_key _cKsk_value)
    set(_cKsk_member kwargs_${_cKsk_key})
    _cpp_Object_set_value(${_cKsk_handle} ${_cKsk_member} "${_cKsk_value}")
endfunction()
