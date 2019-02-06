include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("string_split")

_cpp_add_test(
TITLE "Fails if substring is empty"
SHOULD_FAIL REASON "The substring to split on can not be empty"
"include(string/split)"
"_cpp_string_split(test \"hello world\" \"\")"
)

_cpp_add_test(
TITLE "Can split on space"
"include(string/split)"
"_cpp_string_split(test \"hello world\" \" \")"
"set(corr hello world)"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)

_cpp_add_test(
TITLE "Can split on last character"
"include(string/split)"
"_cpp_string_split(test \"hello world\" \"d\")"
"set(corr \"hello worl\")"
"list(APPEND corr \"\")"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)

_cpp_add_test(
TITLE "Can split on more than one character"
"include(string/split)"
"_cpp_string_split(test \"hello world\" \"ll\")"
"set(corr \"he\" \"o world\")"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)
