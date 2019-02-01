set(TESTS kwargs_ctor
          kwargs_unique
          option
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} kwargs)
endforeach()
