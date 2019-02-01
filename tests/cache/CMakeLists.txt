set(TESTS cache_add_dependency
          cache_add_version
          cache_ctor
          cache_install_dir
          cache_save_source
          cache_save_tarball
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} Cache)
endforeach()
