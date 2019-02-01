include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("exists")

_cpp_add_test(
TITLE "Correctly handles not a real path"
"include(logic/exists)"
"_cpp_exists(test not/a/path)"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Correctly handles a directory"
"include(logic/exists)"
"_cpp_exists(test ${test_prefix})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Correctly handles a file"
"include(logic/exists)"
"_cpp_exists(test ${test_prefix}/toolchain.cmake)"
"_cpp_assert_true(test)"
)
