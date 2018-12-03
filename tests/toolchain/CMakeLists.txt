set(
    TOOLCHAIN_TESTS change_toolchain
                    toolchain_contains
                    toolchain_get
                    write_toolchain
)

foreach(test_i ${TOOLCHAIN_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
