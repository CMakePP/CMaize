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

function(_cpp_write_cmake_build _cwcb_file _cwcb_src _cwcb_dir _cwcb_tc)
    file(WRITE ${_cwcb_file}
"_cpp_run_sub_build(
    ${_cwcb_src}
    NAME external_dependency
    INSTALL_DIR ${_cwcb_dir}
    TOOLCHAIN ${_cwcb_tc}
)"
   )
endfunction()

function(_cpp_build_recipe_dispatch _cbrd_recipe)
    cpp_parse_arguments(
        _cbrd "${ARGN}"
        OPTIONS SOURCE_DIR INSTALL_DIR TOOLCHAIN
        MUST_SET SOURCE_DIR INSTALL_DIR TOOLCHAIN
    )

    #Check directory for a CMakeLists.txt file
    _cpp_exists(_cbrd_is_cmake ${_cbrd_SOURCE_DIR}/CMakeLists.txt)
    if(_cbrd_is_cmake)
        _cpp_write_cmake_build(
            ${_cbrd_recipe}
            ${_cbrd_SOURCE_DIR}
            ${_cbrd_INSTALL_DIR}
            ${_cbrd_TOOLCHAIN}
        )
    endif()
endfunction()
