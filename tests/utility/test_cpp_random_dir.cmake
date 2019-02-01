include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("random_dir")

_cpp_add_test(
TITLE "Basic usage"
"include(utility/random_dir)"
"_cpp_random_dir(dir ${test_prefix}/${test_number})"
"_cpp_is_not_empty(test dir)"
"_cpp_assert_true(test)"
"_cpp_assert_exists(\"\${dir}\")"
)
