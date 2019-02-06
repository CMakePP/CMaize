include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("option")

_cpp_add_test(
TITLE "Sets if unset"
"cpp_option(UNSET_OPTION \"Hello World\")"
"_cpp_assert_equal(\"\${UNSET_OPTION}\" \"Hello World\")"
)

_cpp_add_test(
TITLE "Empty string counts as unset"
"set(EMPTY_STRING \"\")"
"cpp_option(EMPTY_STRING \"Hello World\")"
"_cpp_assert_equal(\"\${EMPTY_STRING}\" \"Hello World\")"
)

_cpp_add_test(
TITLE "Does not override already set option"
"set(A_VARIABLE \"foo\")"
"cpp_option(A_VARIABLE \"bar\")"
"_cpp_assert_equal(\"\${A_VARIABLE}\" \"foo\")"
)
