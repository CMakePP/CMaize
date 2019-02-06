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
include(kwargs/kwarg_value)
include(kwargs/set_kwarg)
include(logic/is_empty)

function(_cpp_Kwargs_set_default _cKsd_handle _cKsd_kwarg _cKsd_value)
    _cpp_Kwargs_kwarg_value(${_cKsd_handle} _cKsd_temp ${_cKsd_kwarg})
    _cpp_is_empty(_cKsd_empty _cKsd_temp)
    if(_cKsd_empty)
        _cpp_Kwargs_set_kwarg(${_cKsd_handle} ${_cKsd_kwarg} "${_cKsd_value}")
    endif()
endfunction()
