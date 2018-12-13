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
