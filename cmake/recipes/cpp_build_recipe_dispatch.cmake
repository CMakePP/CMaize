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
include(recipes/cpp_autotools_conf_cmd)
function(_cpp_autotools_conf _cac_install _cac_src _cac_tc _cac_args)
    find_program(_cac_autoconf autoconf)
    #For autotools we always use make, so don't use CMAKE_MAKE_PROGRAM variable
    #as that'll be changed for other build systems
    find_program(_cac_make make)


    _cpp_autotools_conf_cmd(
        _cac_conf_cmd ${_cac_install} ${_cac_src} ${_cac_tc} "${_cac_args}"
    )
    _cpp_run_sub_build(
        ${_cac_src}
        NAME external_dependency
        NO_INSTALL
        TOOLCHAIN ${_cac_tc}
        CONTENTS
            "include(ExternalProject)"
            "ExternalProject_Add("
            "   external_dependency"
            "   SOURCE_DIR ${_cac_src}"
            "   PATCH_COMMAND ${_cac_src}/autogen.sh"
            "   CONFIGURE_COMMAND ${_cac_conf_cmd}"
            "   BUILD_COMMAND ${_cac_make}"
            "   INSTALL_DIR ${_ccd_install}"
            "   INSTALL_COMMAND ${_cac_make} install"
            ")"
    )
endfunction()


function(_cpp_configure_dispatch _ccd_install _ccd_src _ccd_tc _ccd_args)
    #Assume CMake if CMakeLists.txt
    #Assume autotools if configure.ac
    _cpp_exists(_ccd_is_cmake ${_ccd_src}/CMakeLists.txt)
    _cpp_exists(_ccd_is_autotools ${_ccd_src}/configure.ac)
    if(_ccd_is_cmake)
        _cpp_run_sub_build(
            ${_ccd_src}
            NAME external_dependency
            INSTALL_DIR ${_ccd_install}
            TOOLCHAIN ${_ccd_tc}
        )
    elseif(_ccd_is_autotools)
        _cpp_autotools_conf(
            ${_ccd_install} ${_ccd_src} ${_ccd_tc} "${_ccd_args}"
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
    INSTALL_DIR \${_cbr_install}
    TOOLCHAIN \${_cbr_tc}
    CONTENTS \"${_cwub_contents}\"
)"
        PARENT_SCOPE
    )
endfunction()

function(_cpp_build_recipe_dispatch _cbrd_output)
    cpp_parse_arguments(
        _cbrd "${ARGN}"
        OPTIONS BUILD_MODULE
        LISTS CMAKE_ARGS
    )

    set(_cbrd_start "function(_cpp_build_recipe _cbr_install _cbr_src _cbr_tc)")
    set(_cbrd_include "include(recipes/cpp_build_recipe_dispatch)")
    set(_cbrd_end "endfunction()")
    _cpp_is_not_empty(_cbrd_user_recipe _cbrd_BUILD_MODULE)
    if(_cbrd_user_recipe)
        _cpp_write_user_build(_cbrd_body ${_cbrd_BUILD_MODULE})
    else()
        set(
            _cbrd_args
            "\${_cbr_install} \${_cbr_src} \${_cbr_tc} \"${_cbrd_CMAKE_ARGS}\""
        )
        set(_cbrd_body "_cpp_configure_dispatch(${_cbrd_args})")
    endif()
    set(
        ${_cbrd_output}
        "${_cbrd_start}\n${_cbrd_include}\n${_cbrd_body}\n${_cbrd_end}"
        PARENT_SCOPE
    )
endfunction()
