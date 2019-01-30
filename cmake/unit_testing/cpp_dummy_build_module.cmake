include_guard()
include(utility/set_return)

## This function creates a build module for a dummy cxx package
#
# :param module: An identifier whose value will be set to the module's path
# :param prefix: The path to the source code.
function(_cpp_dummy_build_module _cdbm_module _cdbm_prefix)
    file(WRITE ${_cdbm_prefix}/build-dummy.cmake
         "function(user_build_module src_dir install_dir)
            include(ExternalProject)
            ExternalProject_add(
                dummy_external
                SOURCE_DIR \${src_dir}
                CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=\${CMAKE_TOOLCHAIN_FILE}
                           -DCMAKE_INSTALL_PREFIX=\${install_dir}
            )

         endfunction()"
    )
    _cpp_set_return(${_cdbm_module} ${_cdbm_prefix}/build-dummy.cmake)
endfunction()
