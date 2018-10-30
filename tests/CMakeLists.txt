list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
file(COPY ../cmake/cpp_unit_test_helpers.cmake DESTINATION ${CMAKE_BINARY_DIR}/tests)

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

foreach(subdir_i checks dependency toolchain use_cases)
    add_subdirectory(${subdir_i})
endforeach()
