set(TESTS assert_no_extra_args
          mkdir_if_dne
          random_dir
          set_return
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} utility)
endforeach()
