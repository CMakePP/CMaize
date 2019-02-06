include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("mkdir_if_dne")

_cpp_add_test(
TITLE "Fails if path is empty."
SHOULD_FAIL REASON "Path can not be empty."
"include(utility/mkdir_if_dne)"
"_cpp_mkdir_if_dne(\"\")"
)

_cpp_add_test(
TITLE "Directory already existing is fine"
"include(utility/mkdir_if_dne)"
"_cpp_assert_exists(${test_prefix})"
"_cpp_mkdir_if_dne(${test_prefix})"
"_cpp_assert_exists(${test_prefix})"
)

set(test_dir ${test_prefix}/${test_number}/test_dir)
_cpp_add_test(
TITLE "Makes directory if it does not exist"
"include(utility/mkdir_if_dne)"
"_cpp_assert_does_not_exist(${test_dir})"
"_cpp_mkdir_if_dne(${test_dir})"
"_cpp_assert_exists(${test_dir})"
)
