include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_from_config")

set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Fails to find package w/o path"
CONTENTS
    "include(recipes/cpp_find_from_config)"
    "_cpp_find_from_config(dummy \"\" \"\" \"\")"
    "_cpp_assert_false(dummy_FOUND)"
)

_cpp_add_test(
TITLE "Finds package with path"
CONTENTS
    "include(recipes/cpp_find_from_config)"
    "_cpp_find_from_config(dummy \"\" \"\" ${src_dir}/install)"
    "_cpp_assert_true(dummy_FOUND)"
)
