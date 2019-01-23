include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_value")

_cpp_add_test(
TITLE "Fails if not an object"
SHOULD_FAIL REASON "not_an_object is not a handle to an object"
"include(object/get_value)"
"_cpp_Object_get_value(test not_an_object member)"
)

_cpp_add_test(
TITLE "Fails if object does not have the member"
SHOULD_FAIL REASON "Object has no member member"
"include(object/object_class)"
"include(object/get_value)"
"_cpp_Object_constructor(t)"
"_cpp_Object_get_value(test \${t} member)"
)

_cpp_add_test(
TITLE "Can get a value"
"include(object/object_class)"
"include(object/add_members)"
"include(object/set_value)"
"include(object/get_value)"
"_cpp_Object_constructor(t)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_Object_set_value(\${t} member value)"
"_cpp_Object_get_value(test \${t} member)"
"_cpp_assert_equal(\"\${test}\" \"value\")"
)
