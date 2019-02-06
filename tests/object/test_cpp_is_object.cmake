include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("is_object")

_cpp_add_test(
TITLE "Not a target means not an object"
"include(object/is_object)"
"_cpp_is_object(test not_a_target)"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Target, but doesn't have the appropriate members"
"include(object/is_object)"
"add_library(dummy INTERFACE)"
"_cpp_is_object(test dummy)"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Target and members means it's an object"
"include(object/is_object)"
"include(object/mangle_member)"
"add_library(dummy INTERFACE)"
"_cpp_Object_mangle_member(temp _cpp_member_list)"
"set_target_properties(dummy PROPERTIES \${temp} \"\")"
"_cpp_is_object(test dummy)"
"_cpp_assert_true(test)"
)
