include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("kwargs_ctor")

_cpp_add_test(
TITLE "Fails if the user tries to pass our kwargs multiple times"
SHOULD_FAIL REASON "The kwarg TOGGLES appears 2 times in the kwargs"
"include(kwargs/kwargs)"
"function(dummy_fxn)"
"    _cpp_Kwargs_ctor("
"        test \"\${ARGN}\""
"        TOGGLES A_TOGGLE"
"        LISTS A_LIST"
"        TOGGLES A_TOGGLE2"
"    )"
"endfunction()"
"dummy_fxn(A_TOGGLE)"
)

_cpp_add_test(
TITLE "Errors if there are unparsed kwargs"
SHOULD_FAIL REASON "Found unparsed kwargs: NOT_A_KWARGvalue1."
"include(kwargs/kwargs)"
"function(dummy_fxn)"
"    _cpp_Kwargs_ctor("
"       test \"\${ARGN}\""
"       NOT_A_KWARG value1"
"       TOGGLES A_TOGGLE"
"       LISTS A_LIST"
"    )"
"endfunction()"
"dummy_fxn(A_TOGGLE)"
)

_cpp_add_test(
TITLE "Basic usage"
"include(kwargs/kwargs)"
"function(dummy_fxn)"
"   _cpp_Kwargs_ctor("
"       kwargs \"\${ARGN}\""
"       TOGGLES A_TOGGLE"
"       OPTIONS A_OPTION"
"       LISTS A_LIST"
"   )"
"   _cpp_Kwargs_kwarg_value(\${kwargs} test A_TOGGLE)"
"   _cpp_assert_true(test)"
"   _cpp_Kwargs_kwarg_value(\${kwargs} test A_OPTION)"
"   _cpp_assert_equal(\"\${test}\" \"value\")"
"   _cpp_Kwargs_kwarg_value(\${kwargs} test A_LIST)"
"   set(a_list value1 value2)"
"   _cpp_assert_equal(\"\${test}\" \"\${a_list}\")"
"endfunction()"
"dummy_fxn(A_TOGGLE A_OPTION value A_LIST value1 value2)"
)

_cpp_add_test(
TITLE "Not setting a toggle makes it false"
"include(kwargs/kwargs)"
"function(dummy_fxn)"
"   _cpp_Kwargs_ctor("
"       handle \"\${ARGN}\""
"       TOGGLES A_TOGGLE"
"   )"
"   _cpp_Kwargs_kwarg_value(\${kwargs} test A_TOGGLE)"
"   _cpp_assert_false(test)"
"endfunction()"
"dummy_fxn()"
)

_cpp_add_test(
TITLE "Providing an option kwarg and empty string sets option to empty string"
"include(kwargs/kwargs)"
"function(dummy_fxn)"
"   _cpp_Kwargs_ctor("
"       handle \"\${ARGN}\""
"       TOGGLES TOGGLE1"
"       OPTIONS A_OPTION"
"   )"
"   _cpp_Kwargs_kwarg_value(\${handle} test A_OPTION)"
"   _cpp_is_empty(test_output test)"
"   _cpp_assert_true(test_output)"
"endfunction()"
"dummy_fxn(A_OPTION \"\" TOGGLE1)"
)

_cpp_add_test(
TITLE "Providing a list kwarg and empty string sets option to empty string"
"include(kwargs/kwargs)"
"function(dummy_fxn)"
"   _cpp_Kwargs_ctor("
"       handle \"\${ARGN}\""
"       LISTS A_LIST B_LIST"
"   )"
"   _cpp_Kwargs_kwarg_value(\${handle} test A_LIST)"
"   _cpp_is_empty(test_output test)"
"   _cpp_assert_true(test_output)"
"endfunction()"
"dummy_fxn(A_LIST \"\" B_LIST value1 value2)"
)

_cpp_add_test(
TITLE "Providing a list kwarg and then another kwarg results in empty string"
"include(kwargs/kwargs)"
"function(dummy_fxn)"
"   _cpp_Kwargs_ctor("
"       handle \"\${ARGN}\""
"       LISTS A_LIST B_LIST"
"   )"
"   _cpp_Kwargs_kwarg_value(\${handle} test A_LIST)"
"   _cpp_is_empty(test_output test)"
"   _cpp_assert_true(test_output)"
"endfunction()"
"dummy_fxn(A_LIST B_LIST value1 value2)"
)

_cpp_add_test(
TITLE "Not setting a required option fails"
SHOULD_FAIL REASON "Required option _cKpa_A_OPTION is not set"
"include(kwargs/kwargs)"
"function(dummy_fxn)"
"   _cpp_Kwargs_ctor("
"       handle \"\${ARGN}\""
"       OPTIONS A_OPTION"
"       MUST_SET A_OPTION"
"   )"
"endfunction()"
"dummy_fxn()"
)

_cpp_add_test(
TITLE "Setting a required option to the empty string fails"
SHOULD_FAIL REASON "Required option _cKpa_A_OPTION is not set"
"include(kwargs/kwargs)"
"function(dummy_fxn)"
"   _cpp_Kwargs_ctor("
"       test \"\${ARGN}\""
"       OPTIONS A_OPTION"
"       MUST_SET A_OPTION"
"   )"
"endfunction()"
"dummy_fxn(A_OPTION \"\")"
)
