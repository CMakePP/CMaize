include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("string_cases")

_cpp_add_test(
TITLE "All lowercase string does not readd lowercase"
"include(string/cpp_string_cases)"
"_cpp_string_cases(test hello)"
"set(corr hello HELLO)"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)

_cpp_add_test(
TITLE "All uppercase string does not readd uppercase"
"include(string/cpp_string_cases)"
"_cpp_string_cases(test HELLO)"
"set(corr HELLO hello)"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)
