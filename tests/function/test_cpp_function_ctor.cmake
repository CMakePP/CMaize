include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("function_ctor")

_cpp_add_test(
TITLE "Fails if file name is not provided"
SHOULD_FAIL REASON "Must provide an implementation file."
"include(function/ctor)"
"_cpp_Function_ctor(handle \"\")"
)

_cpp_add_test(
TITLE "Fails if file does not exist."
SHOULD_FAIL REASON "Function implementation dne does not exist."
"include(function/ctor)"
"_cpp_Function_ctor(handle \"dne\")"
)

set(impl_file ${test_prefix}/impl.cmake)
file(WRITE ${impl_file} "")

_cpp_add_test(
TITLE "Can declare a void(void) function"
"include(function/ctor)"
"_cpp_Function_ctor(handle ${impl_file})"
"_cpp_Object_get_value(\${handle} test returns)"
"set(corr \"\")"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
"_cpp_Object_get_value(\${handle} test this)"
"set(corr \"\")"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
"_cpp_Object_get_value(\${handle} test file)"
"set(corr \"${impl_file}\")"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
"_cpp_Object_get_value(\${handle} test kwargs)"
"_cpp_Kwargs_ctor(corr)"
"_cpp_Object_are_equal(\${test} test \${corr})"
"_cpp_assert_true(\${test})"
)

_cpp_add_test(
TITLE "Can declare a r1 r2 r3(void) function"
"include(function/ctor)"
"_cpp_Function_ctor(handle ${impl_file} RETURNS r1 r2 r3)"
"_cpp_Object_get_value(\${handle} test returns)"
"set(corr r1 r2 r3)"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)

_cpp_add_test(
TITLE "Can declare a void(this, void) function"
"include(function/ctor)"
"_cpp_Function_ctor(handle ${impl_file} THIS xxx)"
"_cpp_Object_get_value(\${handle} test this)"
"_cpp_assert_equal(\"\${test}\" \"xxx\")"
)

_cpp_add_test(
TITLE "Can declare a void(kwargs) function"
"include(function/ctor)"
"_cpp_Function_ctor(handle ${impl_file} TOGGLES t1 OPTIONS o1 LISTS l1)"
"_cpp_Object_get_value(\${handle} test kwargs)"
"_cpp_Kwargs_ctor(corr)"
"_cpp_Kwargs_add_keywords(\${corr} TOGGLES t1 OPTIONS o1 LISTS l1)"
"_cpp_Object_are_equal(\${test} test \${corr})"
"_cpp_assert_true(\${test})"
)

_cpp_add_test(
TITLE "Honors NO_KWARGS"
"include(function/ctor)"
"_cpp_Function_ctor(handle ${impl_file} NO_KWARGS)"
"_cpp_Object_get_value(\${handle} test kwargs)"
"_cpp_assert_equal(\"\${test}\" \"\")"
)
