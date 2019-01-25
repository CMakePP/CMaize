include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("set_value")

_cpp_add_test(
TITLE "Fails if not an object"
SHOULD_FAIL REASON "not_an_object is not a handle to an object"
"include(object/set_value)"
"_cpp_Object_set_value(not_an_object member test)"
)

_cpp_add_test(
TITLE "Fails if object does not have the member"
SHOULD_FAIL REASON "Object has no member member"
"include(object/ctor)"
"include(object/set_value)"
"_cpp_Object_ctor(t)"
"_cpp_Object_set_value(\${t} member test)"
)

_cpp_add_test(
TITLE "Can set to string"
"include(object/ctor)"
"include(object/add_members)"
"include(object/set_value)"
"include(object/get_value)"
"_cpp_Object_ctor(t)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_Object_set_value(\${t} member value)"
"_cpp_Object_get_value(\${t} test member)"
"_cpp_assert_equal(\"\${test}\" \"value\")"
)

_cpp_add_test(
TITLE "Can set to list"
"include(object/ctor)"
"include(object/add_members)"
"include(object/set_value)"
"include(object/get_value)"
"_cpp_Object_ctor(t)"
"_cpp_Object_add_members(\${t} member)"
"set(a_list one two)"
"_cpp_Object_set_value(\${t} member \"\${a_list}\")"
"_cpp_Object_get_value(\${t} test member)"
"_cpp_assert_equal(\"\${test}\" \"\${a_list}\")"
)
