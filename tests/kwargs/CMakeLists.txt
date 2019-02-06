set(TESTS kwargs_add_keywords
          kwargs_ctor
          kwargs_parse_argn
          option
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} kwargs)
endforeach()
