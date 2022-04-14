include(cmake_test/cmake_test)

ct_add_test(NAME "cpp_add_cxx_library")
function("${cpp_add_cxx_library}")

    include(cpp/targets/cxx_library)

    set(source_dir "${CMAKE_CURRENT_BINARY_DIR}/a_cxx_library/src")
    set(include_dir "${CMAKE_CURRENT_BINARY_DIR}/a_cxx_library/include")

    ct_add_section(NAME "normal_library")
    function("${normal_library}")

        file(WRITE "${source_dir}/a.cpp" "int test_fxn() { return 0; }")
        file(WRITE "${include_dir}/a.hpp" "#pragma once\nint test_fxn();")

        cpp_add_cxx_library(
            a_cxx_library
            SOURCE_DIR "${source_dir}"
            INCLUDE_DIR "${include_dir}"
        )
        message(FATAL_ERROR "testing")

    endfunction()

endfunction()
