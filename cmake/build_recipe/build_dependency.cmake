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
include(build_recipe/cpp_write_dependency_toolchain)

function(_cpp_BuildRecipe_build_dependency _cBbd_handle _cBbd_install)
    _cpp_Object_has_base(${_cBbd_handle} _cBbd_is_cmake BuildWithCMake)
    _cpp_Object_has_base(${_cBbd_handle} _cBbd_is_module BuildWithModule)
    _cpp_Object_get_value(${_cBbd_handle} _cBbd_old_tc toolchain)
    _cpp_Object_get_value(${_cBbd_handle} _cBbd_args args)
    _cpp_Object_get_value(${_cBbd_handle} _cBbd_src src)
    _cpp_Object_get_value(${_cBbd_handle} _cBbd_depends depends)
    set(_cBbd_new_tc ${_cBbd_src}/toolchain.cmake)
    _cpp_write_dependency_toolchain(
        ${_cBbd_new_tc} ${_cBbd_old_tc} "${_cBbd_args}" "${_cBbd_depends}"
    )
    _cpp_Object_set_value(${_cBbd_handle} toolchain ${_cBbd_new_tc})
    if(_cBbd_is_cmake)
        _cpp_BuildWithCMake_build_dependency(${_cBbd_handle} ${_cBbd_install})
    elseif(_cBbd_is_module)
        _cpp_BuildWithModule_build_dependency(${_cBbd_handle} ${_cBbd_install})
    else()
        _cpp_error("Must override member build_dependency.")
    endif()
    _cpp_Object_set_value(${_cBbd_handle} toolchain ${_cBbd_old_tc})
endfunction()
