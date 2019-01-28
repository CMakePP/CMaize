set(TESTS get_from_disk_ctor)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} get_from_disk)
endforeach()
