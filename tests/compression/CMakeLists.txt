set(
    COMPRESSION_TESTS tar_directory untar_directory
)

foreach(test_i ${COMPRESSION_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
