include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("object_new_target")

_cpp_add_test(
TITLE "Make a class of type T"
"include(object/new_target)"
"_cpp_Object_new_target(test T)"
"string(SUBSTRING \${test} 0 5 prefix)"
"string(SUBSTRING \${test} 10 12 suffix)"
"_cpp_assert_equal(\${prefix} _cpp_)"
"_cpp_assert_equal(\${suffix} _T)"
"_cpp_is_target(is_target \${test})"
"_cpp_assert_true(is_target)"
)

_cpp_add_test(
TITLE "No members set"
"include(object/new_target)"
"_cpp_Object_new_target(t T)"
"_cpp_Object_get_members(test \${t})"
"_cpp_assert_equal(\"\${test}\" \"\")"
)

_cpp_add_test(
TITLE "1 member set"
"include(object/new_target)"
"_cpp_Object_new_target(t T)"
"_cpp_Object_add_members(\${t} member1)"
"_cpp_Object_get_members(test \${t})"
"_cpp_assert_equal(\"\${test}\" \"_cpp_member1\")"
"_cpp_Object_get_value(test \${t} member1)"
"_cpp_assert_equal(\"\${test}\" \"NULL\")"
)

_cpp_add_test(
TITLE "Can't declare same member twice"
SHOULD_FAIL REASON "Failed to add member member1.  Already present."
"include(object/new_target)"
"_cpp_Object_new_target(t T)"
"_cpp_Object_add_members(\${t} member1 member1)"
)

_cpp_add_test(
 TITLE "3 members set"
"include(object/new_target)"
"_cpp_Object_new_target(t T)"
"_cpp_Object_add_members(\${t} member1 member2 member3)"
"_cpp_Object_get_members(test \${t})"
"set(corr _cpp_member1 _cpp_member2 _cpp_member3)"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)

_cpp_add_test(
TITLE "New Object convenience wrapper works"
"include(object/new_target)"
"_cpp_Object_new_object(t T member1)"
"_cpp_Object_get_members(test \${t})"
"_cpp_assert_equal(\"\${test}\" \"_cpp_member1\")"
)

_cpp_add_test(
TITLE "Add members sets values to NULL"
"include(object/new_target)"
"_cpp_Object_new_object(t T member1)"
"_cpp_Object_get_value(test \${t} member1)"
"_cpp_assert_equal(\"\${test}\" \"NULL\")"
)

_cpp_add_test(
TITLE "Get value fails for non-existant member"
SHOULD_FAIL REASON "Object has no member member2"
"include(object/new_target)"
"_cpp_Object_new_object(t T member1)"
"_cpp_Object_get_value(test \${t} member2)"
)

_cpp_add_test(
TITLE "Set value works"
"include(object/new_target)"
"_cpp_Object_new_object(t T member1)"
"_cpp_Object_set_value(\${t} member1 value1)"
"_cpp_Object_get_value(test \${t} member1)"
"_cpp_assert_equal(\"\${test}\" \"value1\")"
)

_cpp_add_test(
TITLE "Set value fails for non-existant member"
SHOULD_FAIL REASON "Object has no member member2"
"include(object/new_target)"
"_cpp_Object_new_object(t T member1)"
"_cpp_Object_set_value(\${t} member2 value2)"
)
