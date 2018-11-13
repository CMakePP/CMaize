include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_package")

set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Find from config"
CONTENTS
    "_cpp_find_from_config(dummy \"\" \"\" ${src_dir}/install)"
    "_cpp_assert_true(dummy_FOUND)"
)
