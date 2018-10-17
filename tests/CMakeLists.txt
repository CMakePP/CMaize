list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

file(COPY cpp_unit_test_helpers.cmake DESTINATION ${CMAKE_BINARY_DIR}/tests)

include(cpp_print) #For debug printing

function(cpp_cmake_unit_test _ccut_name)
    get_filename_component(_ccut_test_file test_${_ccut_name}.cmake REALPATH)
    add_test(
            NAME ${_ccut_name}
            COMMAND ${CMAKE_COMMAND}
            "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
            -P ${_ccut_test_file}
    )
    _cpp_debug_print("Added CMake Unit Test:")
    _cpp_debug_print("  Name: ${_ccut_name}")
    _cpp_debug_print("  File: ${_ccut_test_file}")
endfunction()

cpp_cmake_unit_test(cpp_assert)
cpp_cmake_unit_test(cpp_build_recipes)
cpp_cmake_unit_test(cpp_checks)
cpp_cmake_unit_test(cpp_cmake_helpers)
cpp_cmake_unit_test(cpp_main)
cpp_cmake_unit_test(cpp_dependency)
cpp_cmake_unit_test(cpp_options)
cpp_cmake_unit_test(cpp_print)
cpp_cmake_unit_test(cpp_targets)
cpp_cmake_unit_test(cpp_toolchain)
