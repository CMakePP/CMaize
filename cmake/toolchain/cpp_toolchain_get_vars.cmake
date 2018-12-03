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
