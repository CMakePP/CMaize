list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
file(COPY cpp_unit_test_helpers.cmake DESTINATION ${CMAKE_BINARY_DIR}/tests)

include(cpp_print) #For debug printing

function(cpp_cmake_unit_test _ccut_name)
    get_filename_component(
        _ccut_test_file
        test_cpp_${_ccut_name}.cmake
        REALPATH
    )
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

set(
    CPP_UNIT_TESTS change_toolchain checks find_dependency
                   find_or_build_dependency get_gh_url get_source_tarball
                   record_find untar_directory write_toolchain xor
)
foreach(cpp_unit_test_i ${CPP_UNIT_TESTS})
    cpp_cmake_unit_test(${cpp_unit_test_i})
endforeach()

