include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_members")

_cpp_add_test(
TITLE "Fails if not an object"
SHOULD_FAIL REASON "not_an_object is not a handle to an object"
"include(object/get_members)"
"_cpp_Object_get_members(test not_an_object)"
)

_cpp_add_test(
TITLE "Can get default empty member list"
"include(object/object_class)"
"include(object/get_members)"
"_cpp_Object_constructor(t)"
"_cpp_Object_get_members(test \${t})"
"_cpp_assert_equal(\"\${test}\" \"\")"
)

_cpp_add_test(
TITLE "Can get an added member"
"include(object/object_class)"
"include(object/add_members)"
"include(object/has_member)"
"_cpp_Object_constructor(t)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_Object_get_members(test \${t} member)"
"_cpp_assert_equal(\"\${test}\" \"member\")"
)
