include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("kwargs_add_keywords")

_cpp_add_test(
TITLE "Defaults are empty"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords(\${kwargs})"
"_cpp_Object_get_value(\${kwargs} list toggles)"
"_cpp_is_empty(test list)"
"_cpp_assert_true(test)"
"_cpp_Object_get_value(\${kwargs} list options)"
"_cpp_is_empty(test list)"
"_cpp_assert_true(test)"
"_cpp_Object_get_value(\${kwargs} list lists)"
"_cpp_is_empty(test list)"
"_cpp_assert_true(test)"
"_cpp_Object_get_value(\${kwargs} list unparsed)"
"_cpp_is_empty(test list)"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Can set a toggle and it defaults to FALSE"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords(\${kwargs} TOGGLES a_toggle)"
"_cpp_Object_get_value(\${kwargs} list toggles)"
"_cpp_assert_equal(\"\${list}\" \"a_toggle\")"
"_cpp_Kwargs_kwarg_value(\${kwargs} test a_toggle)"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Can set an option and it defaults to empty"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords(\${kwargs} OPTIONS an_option)"
"_cpp_Object_get_value(\${kwargs} list options)"
"_cpp_assert_equal(\${list} \"an_option\")"
"_cpp_Kwargs_kwarg_value(\${kwargs} test an_option)"
"_cpp_assert_equal(\"\${test}\" \"\")"
)

_cpp_add_test(
TITLE "Can set a list and it defaults to empty"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords(\${kwargs} LISTS a_list)"
"_cpp_Object_get_value(\${kwargs} list lists)"
"_cpp_assert_equal(\${list} \"a_list\")"
"_cpp_Kwargs_kwarg_value(\${kwargs} test a_list)"
"_cpp_assert_equal(\"\${test}\" \"\")"
)

_cpp_add_test(
TITLE "Can set multiple lists"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords(\${kwargs} LISTS a_list b_list)"
"_cpp_Object_get_value(\${kwargs} list lists)"
"set(da_lists a_list b_list)"
"_cpp_assert_equal(\"\${list}\" \"\${da_lists}\")"
)

_cpp_add_test(
TITLE "Can combine toggles, options, and lists"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords("
"   \${kwargs} TOGGLES a_toggle OPTIONS an_option LISTS a_list"
")"
"_cpp_Object_get_value(\${kwargs} list toggles)"
"_cpp_assert_equal(\"\${list}\" \"a_toggle\")"
"_cpp_Object_get_value(\${kwargs} list options)"
"_cpp_assert_equal(\"\${list}\" \"an_option\")"
"_cpp_Object_get_value(\${kwargs} list lists)"
"_cpp_assert_equal(\"\${list}\" \"a_list\")"
)

_cpp_add_test(
TITLE "Multiples of all"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_Kwargs_add_keywords("
"   \${kwargs}"
"   TOGGLES a_toggle b_toggle"
"   OPTIONS an_option another_option"
"   LISTS a_list b_list"
")"
"_cpp_Object_get_value(\${kwargs} list toggles)"
"set(corr a_toggle b_toggle)"
"_cpp_assert_equal(\"\${list}\" \"\${corr}\")"
"_cpp_Object_get_value(\${kwargs} list options)"
"set(corr an_option another_option)"
"_cpp_assert_equal(\"\${list}\" \"\${corr}\")"
"_cpp_Object_get_value(\${kwargs} list lists)"
"set(corr a_list b_list)"
"_cpp_assert_equal(\"\${list}\" \"\${corr}\")"
)
