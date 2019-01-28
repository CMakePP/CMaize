include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_type")

_cpp_add_test(
TITLE "Works for Object class"
"include(object/ctor)"
"include(object/set_type)"
"include(object/get_type)"
"_cpp_Object_ctor(t)"
"_cpp_Object_get_type(\${t} test)"
"_cpp_assert_equal(\"\${test}\" \"Object\")"
)

_cpp_add_test(
TITLE "Works for derived class"
"include(object/ctor)"
"include(object/set_type)"
"include(object/get_type)"
"_cpp_Object_ctor(t)"
"_cpp_Object_set_type(\${t} value)"
"_cpp_Object_get_type(\${t} test)"
"_cpp_assert_equal(\"\${test}\" \"value\")"
)
