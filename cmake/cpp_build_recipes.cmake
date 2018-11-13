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

function(_cpp_build_local_dependency)
    set(_cbld_O_kwargs NAME SOURCE_DIR INSTALL_DIR TOOLCHAIN BINARY_DIR)
    set(_cbld_M_kwargs CMAKE_ARGS)
    cmake_parse_arguments(
            _cbld
            ""
            "${_cbld_O_kwargs}"
            "${_cbld_M_kwargs}"
            "${ARGN}"
    )
    cpp_option(_cbld_TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}")
    cpp_option(_cbld_BINARY_DIR "${CMAKE_BINARY_DIR}/${_cbld_NAME}")
    _cpp_assert_true(_cbld_NAME _cbld_SOURCE_DIR _cbld_INSTALL_DIR)

    #Can't rely on the toolchain b/c CMake's option command overrides it...
    set(_cbld_cmake_args "-DCMAKE_INSTALL_PREFIX=${_cbld_INSTALL_DIR}\n")
    set(
            _cbld_cmake_args
            "${_cbld_cmake_args}-DCMAKE_TOOLCHAIN_FILE=${_cbld_TOOLCHAIN}\n"
    )
    foreach(_cbld_arg_i ${_cbld_CMAKE_ARGS})
        set(
                _cbld_cmake_args
                "${_cbld_cmake_args}-D${_cbld_arg_i}\n"
        )
    endforeach()

    _cpp_run_sub_build(
            ${_cbld_BINARY_DIR}
            NAME ${_cbld_NAME}
            OUTPUT _cbld_output
            NO_INSTALL
            TOOLCHAIN ${_cbld_TOOLCHAIN}
            CONTENTS "include(ExternalProject)"
            "ExternalProject_Add("
            "  ${_cbld_NAME}_External"
            "  SOURCE_DIR ${_cbld_SOURCE_DIR}"
            "  INSTALL_DIR ${_cbld_BINARY_DIR}/install"
            "  CMAKE_ARGS ${_cbld_cmake_args}"
            ")"
    )
    _cpp_debug_print("${_cbld_output}")
endfunction()

function(_cpp_build_recipe_dispatch _cbrd_recipe _cbrd_dir)
    #Check directory for a CMakeLists.txt file

endfunction()
