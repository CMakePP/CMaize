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

function(_cpp_write_cmake_build _cwcb_return _cwcb_src)
    set(${_cwcb_return}
"_cpp_run_sub_build(
    ${_cwcb_src}
    NAME external_dependency
    INSTALL_DIR \${_cbr_install}
    TOOLCHAIN \${_cbr_tc}
)"
        PARENT_SCOPE
   )
endfunction()

function(_cpp_write_user_build _cwub_return _cwub_src _cwub_recipe)
    file(READ ${_cwub_recipe} _cwub_contents)
    set(${_cwub_return}
"_cpp_run_sub_build(
    ${_cwub_src}
    NAME external_dependency
    INSTALL_DIR \${_cbr_dir}
    TOOLCHAIN \${_cbr_tc}
    CONTENTS ${_cwub_contents}
"
        PARENT_SCOPE
    )
endfunction()

function(_cpp_build_recipe_header _cbrh_recipe)
    set(
        ${_cbrh_recipe}

        PARENT_SCOPE
    )
endfunction()

function(_cpp_build_recipe_dispatch _cbrd_output _cbrd_src)
    cpp_parse_arguments(_cbrd "${ARGN}" OPTION BUILD_MODULE)

    set(_cbrd_header "function(_cpp_build_recipe _cbr_install _cbr_tc)")
    set(_cbrd_footer "endfunction()")

    #Check directory for a CMakeLists.txt file
    _cpp_exists(_cbrd_is_cmake ${_cbrd_src}/CMakeLists.txt)
    _cpp_is_not_empty(_cbrd_user_recipe _cbrd_BUILD_MODULE)
    if(_cbrd_user_recipe)
        _cpp_write_user_build(${_cbrd_body} ${_cbrd_src} ${_cbrd_BUILD_MODULE})
    elseif(_cbrd_is_cmake)
        _cpp_write_cmake_build(${_cbrd_body} ${_cbrd_src})
    else()
        _cpp_error("Not sure how to build dependency's source code")
    endif()
    set(${_cbrd_output} "${_cbrd_header}${_cbrd_body}${_cbrd_footer}")
endfunction()
