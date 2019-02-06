include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("is_list")

_cpp_add_test(
TITLE "Empty string is not list"
"include(logic/is_list)"
"_cpp_is_list(test \"\")"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Single element is not list"
"include(logic/is_list)"
"_cpp_is_list(test \"hi\")"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "A list is a list"
"include(logic/is_list)"
"set(a_list one two)"
"_cpp_is_list(test \"\${a_list}\")"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Empty string plus item is a list"
"include(logic/is_list)"
"set(a_list one)"
"list(APPEND a_list \"\")"
"_cpp_is_list(test \"\${a_list}\")"
"_cpp_assert_true(test)"
)

set(escape "\\\\\\\\\\\\\\\\\\\\\\;")
_cpp_add_test(
TITLE "Escaped semicolon is not a list"
"include(logic/is_list)"
"_cpp_is_list(test \"one${escape}two\")"
"_cpp_assert_false(test)"
)
