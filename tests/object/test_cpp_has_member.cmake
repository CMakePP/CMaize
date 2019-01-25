include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("has_member")

_cpp_add_test(
TITLE "Fails if not an object"
SHOULD_FAIL REASON "not_an_object is not a handle to an object"
"include(object/has_member)"
"_cpp_Object_has_member(not_an_object test member)"
)

_cpp_add_test(
TITLE "By default has no members"
"include(object/ctor)"
"include(object/has_member)"
"_cpp_Object_ctor(t)"
"_cpp_Object_has_member(\${t} test member)"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Can find added member"
"include(object/ctor)"
"include(object/add_members)"
"include(object/has_member)"
"_cpp_Object_ctor(t)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_Object_has_member(\${t} test member)"
"_cpp_assert_true(test)"
)
