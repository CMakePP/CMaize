set(TESTS get_from_disk_ctor
          get_from_disk_get_source
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} get_from_disk)
endforeach()
