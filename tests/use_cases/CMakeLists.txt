set(
    USE_CASE_TESTS  multiple_caches
                    provided_lists
                    provided_toolchain
)

foreach(test_i ${USE_CASE_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
