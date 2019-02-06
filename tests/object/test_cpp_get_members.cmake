include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_members")

_cpp_add_test(
TITLE "Fails if not an object"
SHOULD_FAIL REASON "not_an_object is not a handle to an object"
"include(object/get_members)"
"_cpp_Object_get_members(not_an_object test)"
)

_cpp_add_test(
TITLE "Can get default member list"
"include(object/ctor)"
"include(object/get_members)"
"_cpp_Object_ctor(t)"
"_cpp_Object_get_members(\${t} test)"
"_cpp_assert_equal(\"\${test}\" \"_cpp_type\")"
)

_cpp_add_test(
TITLE "Can get an added member"
"include(object/ctor)"
"include(object/add_members)"
"include(object/has_member)"
"_cpp_Object_ctor(t)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_Object_get_members(\${t} test member)"
"set(corr _cpp_type member)"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)
