include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("kwargs_ctor")

_cpp_add_test(
TITLE "Basic usage"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords("
"   \${kwargs} TOGGLES A_TOGGLE OPTIONS A_OPTION LISTS A_LIST"
")"
"_cpp_Kwargs_parse_argn("
"   \${kwargs} A_TOGGLE A_OPTION value A_LIST value1 value2"
")"
"_cpp_Kwargs_kwarg_value(\${kwargs} test A_TOGGLE)"
"_cpp_assert_true(test)"
"_cpp_Kwargs_kwarg_value(\${kwargs} test A_OPTION)"
"_cpp_assert_equal(\"\${test}\" \"value\")"
"_cpp_Kwargs_kwarg_value(\${kwargs} test A_LIST)"
"set(a_list value1 value2)"
"_cpp_assert_equal(\"\${test}\" \"\${a_list}\")"
)

_cpp_add_test(
TITLE "Providing an option kwarg and empty string sets option to empty string"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords(\${kwargs} TOGGLES TOGGLE1 OPTIONS A_OPTION)"
"_cpp_kwargs_parse_argn(\${kwargs} A_OPTION \"\" TOGGLE1)"
"_cpp_Kwargs_kwarg_value(\${kwargs} test A_OPTION)"
"_cpp_is_empty(test_output test)"
"_cpp_assert_true(test_output)"
)

_cpp_add_test(
TITLE "Providing a list kwarg and empty string sets option to empty string"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords(\${kwargs} LISTS A_LIST B_LIST)"
"_cpp_Kwargs_parse_argn(\${kwargs} A_LIST \"\" B_LIST value1 value2)"
"_cpp_Kwargs_kwarg_value(\${kwargs} test A_LIST)"
"_cpp_is_empty(test_output test)"
"_cpp_assert_true(test_output)"
)

_cpp_add_test(
TITLE "Providing a list kwarg and then another kwarg results in empty string"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords(\${kwargs} LISTS A_LIST B_LIST)"
"_cpp_Kwargs_parse_argn(\${kwargs} A_LIST B_LIST value1 value2)"
"_cpp_Kwargs_kwarg_value(\${kwargs} test A_LIST)"
"_cpp_is_empty(test_output test)"
"_cpp_assert_true(test_output)"
)

_cpp_add_test(
TITLE "Leaves set toggles alone"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords(\${kwargs} TOGGLES toggle_a toggle_b)"
"_cpp_Kwargs_set_kwarg(\${kwargs} toggle_a TRUE)"
"_cpp_Kwargs_kwarg_value(\${kwargs} test toggle_a)"
"_cpp_assert_true(test)"
"_cpp_Kwargs_kwarg_value(\${kwargs} test toggle_b)"
"_cpp_assert_false(test)"
"_cpp_Kwargs_parse_argn(\${kwargs} toggle_b)"
"_cpp_Kwargs_kwarg_value(\${kwargs} test toggle_a)"
"_cpp_assert_true(test)"
"_cpp_Kwargs_kwarg_value(\${kwargs} test toggle_b)"
"_cpp_assert_true(test)"
)
