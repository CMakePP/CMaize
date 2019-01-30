include_guard()

include(cpp_cmake_helpers)
include(object/object)

function(_cpp_BuildWithCMake_build_dependency _cBbd_handle _cBbd_install)
    _cpp_Object_get_value(${_cBbd_handle} _cBbd_src src)
    _cpp_Object_get_value(${_cBbd_handle} _cBbd_tc toolchain)
    _cpp_run_sub_build(
        ${_cBbd_src}
        NAME external_dependency
        INSTALL_DIR ${_cBbd_install}
        TOOLCHAIN ${_cBbd_tc}
    )
endfunction()
