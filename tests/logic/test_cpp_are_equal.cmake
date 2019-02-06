include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("are_equal")

_cpp_add_test(
TITLE "Empty string equals itself"
"include(logic/are_equal)"
"_cpp_are_equal(test \"\" \"\")"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Empty string does not equal something"
"include(logic/are_equal)"
"_cpp_are_equal(test \"\" \" \")"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Same strings"
"include(logic/are_equal)"
"_cpp_are_equal(test \"hello world\" \"hello world\")"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Different strings"
"include(logic/are_equal)"
"_cpp_are_equal(test \"hello world\" \"goodbye world\")"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Same list"
"include(logic/are_equal)"
"set(list1 one two three)"
"_cpp_are_equal(test \"\${list1}\" \"\${list1}\")"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Different lists"
"include(logic/are_equal)"
"set(list1 one two three)"
"set(list2 two three four)"
"_cpp_are_equal(test \"\${list1}\" \"\${list2}\")"
"_cpp_assert_false(test)"
)
