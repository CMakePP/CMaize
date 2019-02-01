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

include(build_recipe/ctor)
include(utility/set_return)

function(_cpp_BuildWithCMake_ctor _cBc_handle _cBc_name _cBc_version _cBc_src
                                  _cBc_tc _cBc_args)
    _cpp_BuildRecipe_ctor(
        _cBc_temp
        "${_cBc_name}"
        "${_cBc_version}"
        "${_cBc_src}"
        "${_cBc_tc}"
        "${_cBc_args}"
    )
    _cpp_Object_set_type(${_cBc_temp} BuildWithCMake)
    _cpp_set_return(${_cBc_handle} ${_cBc_temp})
endfunction()
