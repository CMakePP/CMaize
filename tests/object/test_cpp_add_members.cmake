include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("add_members")

_cpp_add_test(
TITLE "Fails if not an object"
SHOULD_FAIL REASON "not_an_object is not a handle to an object"
"include(object/add_members)"
"_cpp_Object_add_members(not_an_object member)"
)

_cpp_add_test(
TITLE "Can add a member"
"include(object/object_class)"
"include(object/add_members)"
"include(object/get_members)"
"_cpp_Object_constructor(t)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_Object_get_members(test \${t})"
"_cpp_assert_equal(\"\${test}\" \"member\")"
)

_cpp_add_test(
TITLE "Can add multiple members"
"include(object/object_class)"
"include(object/add_members)"
"include(object/get_members)"
"_cpp_Object_constructor(t)"
"_cpp_Object_add_members(\${t} member1 member2)"
"_cpp_Object_get_members(test \${t})"
"set(corr member1 member2)"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)

_cpp_add_test(
TITLE "Can't add member twice"
SHOULD_FAIL REASON "Failed to add member member1.  Already present."
"include(object/object_class)"
"include(object/add_members)"
"_cpp_Object_constructor(t)"
"_cpp_Object_add_members(\${t} member1 member1)"
)
