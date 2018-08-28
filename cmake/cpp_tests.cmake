################################################################################
#            Functions for delcaring unit tests in various languages           #
################################################################################
include(cpp_print) #For debug printing

function(cpp_cmake_unit_test _ccut_name _ccut_path)
    get_filename_component(_ccut_test_file test_${_ccut_name}.cmake REALPATH)
    set(_ccut_args "-DCMAKE_MODULE_PATH=${_ccut_path}")
    add_test(
            NAME ${_ccut_name}
            COMMAND ${CMAKE_COMMAND} "${_ccut_args}" -P ${_ccut_test_file}
    )
    _cpp_debug_print("Added CMake Unit Test:")
    _cpp_debug_print("  Name: ${_ccut_name}")
    _cpp_debug_print("  File: ${_ccut_test_file}")
    _cpp_debug_print("  CMAKE_MODULE_PATH: ${_ccut_path}")
endfunction()
