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

function(_cpp_write_user_build _cwub_file _cwub_src _cwub_dir _cwub_tc
                               _cwub_recipe)
    file(READ ${_cwub_recipe} _cwub_contents)
    file(WRITE ${_cwub_file}
"_cpp_run_sub_build(
    ${_cwub_src}
    NAME external_dependency
    INSTALL_DIR ${_cwub_dir}
    TOOLCHAIN ${_cwub_tc}
    CONTENTS ${_cwub_contents}
"
    )
endfunction()

function(_cpp_build_recipe_dispatch _cbrd_output _cbrd_src _cbrd_tc
                                    _cbrd_install _cbrd_build)
    #Check directory for a CMakeLists.txt file
    _cpp_exists(_cbrd_is_cmake ${_cbrd_src}/CMakeLists.txt)
    _cpp_is_not_empty(_cbrd_user_recipe _cbrd_build)
    if(_cbrd_user_recipe)
        _cpp_write_user_build(
            ${_cbrd_output}
            ${_cbrd_src}
            ${_cbrd_install}
            ${_cbrd_tc}
            ${_cbrd_build}
        )
    elseif(_cbrd_is_cmake)
        _cpp_write_cmake_build(
            ${_cbrd_output}
            ${_cbrd_src}
            ${_cbrd_install}
            ${_cbrd_tc}
        )
    else()
        _cpp_error("Not sure how to build dependency's source code")
    endif()
endfunction()
