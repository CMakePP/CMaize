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
include(build_recipe/build_with_cmake/build_with_cmake)
include(build_recipe/build_with_module/build_with_module)

function(_cpp_BuildRecipe_build_dependency _cBbd_handle _cBbd_install)
    _cpp_Object_has_base(${_cBbd_handle} _cBbd_is_cmake BuildWithCMake)
    _cpp_Object_has_base(${_cBbd_handle} _cBbd_is_module BuildWithModule)
    if(_cBbd_is_cmake)
        _cpp_BuildWithCMake_build_dependency(${_cBbd_handle} ${_cBbd_install})
    elseif(_cBbd_is_module)
        _cpp_BuildWithModule_build_dependency(${_cBbd_handle} ${_cBbd_install})
    else()
        _cpp_error("Must override member build_dependency.")
    endif()
endfunction()
