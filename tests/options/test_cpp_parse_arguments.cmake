include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("parse_arguments")

_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "function(dummy_fxn)"
    "   cpp_parse_arguments("
    "       test \"\${ARGN}\""
    "       TOGGLES A_TOGGLE"
    "       OPTIONS A_OPTION"
    "       LISTS A_LIST"
    "   )"
    "   _cpp_assert_true(test_A_TOGGLE)"
    "   _cpp_assert_equal(\"\${test_A_OPTION}\" \"value\")"
    "   set(a_list value1 value2)"
    "   _cpp_assert_equal(\"\${test_A_LIST}\" \"\${a_list}\")"
    "endfunction()"
    "dummy_fxn(A_TOGGLE A_OPTION value A_LIST value1 value2)"
)

_cpp_add_test(
TITLE "Not setting a toggle makes it false"
CONTENTS
    "function(dummy_fxn)"
    "   cpp_parse_arguments("
    "       test \"\${ARGN}\""
    "       TOGGLES A_TOGGLE"
    "   )"
    "   _cpp_assert_false(test_A_TOGGLE)"
    "endfunction()"
    "dummy_fxn()"
)

_cpp_add_test(
TITLE "Not setting a required option fails"
SHOULD_FAIL REASON "Required option test_A_OPTION is not set"
CONTENTS
    "function(dummy_fxn)"
    "   cpp_parse_arguments("
    "       test \"\${ARGN}\""
    "       OPTIONS A_OPTION"
    "       MUST_SET A_OPTION"
    "   )"
    "endfunction()"
    "dummy_fxn()"
)
