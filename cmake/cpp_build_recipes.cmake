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

function(_cpp_configure_dispatch _ccd_install _ccd_src _ccd_tc)
    #Check directory for a CMakeLists.txt file
    _cpp_exists(_ccd_is_cmake ${_ccd_src}/CMakeLists.txt)
    if(_ccd_is_cmake)
        _cpp_run_sub_build(
            ${_ccd_src}
            NAME external_dependency
            INSTALL_DIR ${_ccd_install}
            TOOLCHAIN ${_ccd_tc}
        )
    else()
        _cpp_error(
            "Could not auto-configure source code: ${_ccd_src}."
            " Troubleshooting: Does the package use a supported build system"
            " generator?"
        )
    endif()
endfunction()

function(_cpp_write_user_build _cwub_return _cwub_recipe)
    file(READ ${_cwub_recipe} _cwub_contents)
    set(${_cwub_return}
"_cpp_run_sub_build(
    \${_cbr_src}
    NAME external_dependency
    INSTALL_DIR \${_cbr_dir}
    TOOLCHAIN \${_cbr_tc}
    CONTENTS ${_cwub_contents}
"
        PARENT_SCOPE
    )
endfunction()

function(_cpp_build_recipe_dispatch _cbrd_output)
    cpp_parse_arguments(_cbrd "${ARGN}" OPTION BUILD_MODULE)

    set(
        _cbrd_header
        "function(_cpp_build_recipe _cbr_install _cbr_src _cbr_tc)"
    )
    set(_cbrd_footer "endfunction()")

    _cpp_is_not_empty(_cbrd_user_recipe _cbrd_BUILD_MODULE)
    if(_cbrd_user_recipe)
        _cpp_write_user_build(_cbrd_body ${_cbrd_BUILD_MODULE})
    else()
        set(
           _cbrd_body
           "_cpp_configure_dispatch(\${_cbr_install} \${_cbr_src} \${_cbr_tc})"
        )
    endif()
    set(${_cbrd_output} "${_cbrd_header}${_cbrd_body}${_cbrd_footer}")
endfunction()
