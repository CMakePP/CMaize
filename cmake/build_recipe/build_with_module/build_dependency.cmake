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

include(cpp_cmake_helpers)
include(object/object)

## Implements ``build_dependency`` for the BuildWithModule class
#
# User specified build modules are required to define a function
# ``user_build_module`` that takes a path to the root of the source it is to
# build and the path where the package should be installed. The module is
# responsible for filling in the gaps.
#
# :param handle: An identifier holding a handle to a BuildWithModule instance.
# :param install: The path to where the dependency should be installed.
function(_cpp_BuildWithModule_build_dependency _cBbd_handle _cBbd_install)
    _cpp_Object_get_value(${_cBbd_handle} _cBbd_module module_path)
    _cpp_Object_get_value(${_cBbd_handle} _cBbd_src src)
    _cpp_Object_get_value(${_cBbd_handle} _cBbd_args args)
    _cpp_Object_get_value(${_cBbd_handle} _cBbd_tc toolchain)
    string(RANDOM _cBbd_random_dir)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/${_cBbd_random_dir})
    _cpp_run_sub_build(
        ${CMAKE_BINARY_DIR}/${_cBbd_random_dir}
        NAME external_dependency
        NO_INSTALL
        CMAKE_ARGS "${_cBbd_args}"
        INSTALL_DIR ${_cBbd_install}
        TOOLCHAIN   ${_cBbd_tc}
        CONTENTS    "include(${_cBbd_module})
                     user_build_module(${_cBbd_src} ${_cBbd_install})"
    )
endfunction()
