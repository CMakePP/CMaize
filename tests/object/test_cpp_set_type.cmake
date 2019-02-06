include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("set_type")

_cpp_add_test(
TITLE "Fails if not an object"
SHOULD_FAIL REASON "not_an_object is not a handle to an object"
"include(object/set_type)"
"_cpp_Object_set_type(not_an_object test)"
)

_cpp_add_test(
TITLE "Can set"
"include(object/ctor)"
"include(object/set_type)"
"include(object/get_value)"
"_cpp_Object_ctor(t)"
"_cpp_Object_set_type(\${t} value)"
"_cpp_Object_get_value(\${t} test _cpp_type)"
"set(corr Object value)"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)
