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

function(_cpp_toolchain_get_vars _ctgv_return)
    set(_ctgv_vars CMAKE_C_COMPILER CMAKE_CXX_COMPILER CMAKE_Fortran_COMPILER
        CMAKE_SYSTEM_NAME
        CMAKE_MODULE_PATH CMAKE_PREFIX_PATH
        BUILD_SHARED_LIBS
        CMAKE_SHARED_LIBRARY_PREFIX CMAKE_SHARED_LIBRARY_SUFFIX
        CMAKE_STATIC_LIBRARY_PREFIX CMAKE_STATIC_LIBRARY_SUFFIX
        CPP_INSTALL_CACHE CPP_GITHUB_TOKEN
        )
    set(${_ctgv_return} "${_ctgv_vars}" PARENT_SCOPE)
endfunction()
