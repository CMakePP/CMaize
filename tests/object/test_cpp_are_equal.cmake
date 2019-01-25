include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("are_equal")

_cpp_add_test(
TITLE "Fails if lhs is not an object"
SHOULD_FAIL REASON "not_an_object is not a handle to an object"
"include(object/object)"
"_cpp_Object_constructor(rhs)"
"_cpp_Object_are_equal(test not_an_object \${rhs})"
)

_cpp_add_test(
TITLE "Fails if rhs is not an object"
SHOULD_FAIL REASON "not_an_object is not a handle to an object"
"include(object/object)"
"_cpp_Object_constructor(lhs)"
"_cpp_Object_are_equal(test \${lhs} not_an_object)"
)

_cpp_add_test(
TITLE "Empty objects are equal"
 "include(object/object)"
"_cpp_Object_constructor(lhs)"
"_cpp_Object_constructor(rhs)"
"_cpp_Object_are_equal(test \${lhs} \${rhs})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Different members are not equal"
"include(object/object)"
"_cpp_Object_constructor(lhs)"
"_cpp_Object_constructor(rhs)"
"_cpp_Object_add_members(\${rhs} member1)"
"_cpp_Object_are_equal(test \${lhs} \${rhs})"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Same members, same values are equal"
"include(object/object)"
"_cpp_Object_constructor(lhs)"
"_cpp_Object_constructor(rhs)"
"_cpp_Object_add_members(\${lhs} member1)"
"_cpp_Object_add_members(\${rhs} member1)"
"_cpp_Object_are_equal(test \${lhs} \${rhs})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Same members, different values are not equal"
"include(object/object)"
"_cpp_Object_constructor(lhs)"
"_cpp_Object_constructor(rhs)"
"_cpp_Object_add_members(\${lhs} member1)"
"_cpp_Object_add_members(\${rhs} member1)"
"_cpp_Object_set_value(\${lhs} member1 value1)"
"_cpp_Object_are_equal(test \${lhs} \${rhs})"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "One member object, other not are not equal"
"include(object/object)"
"_cpp_Object_constructor(lhs)"
"_cpp_Object_constructor(rhs)"
"_cpp_Object_constructor(sub)"
"_cpp_Object_add_members(\${lhs} member1)"
"_cpp_Object_add_members(\${rhs} member1)"
"_cpp_Object_set_value(\${lhs} member1 \${sub})"
"_cpp_Object_are_equal(test \${lhs} \${rhs})"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Different member objects are not equal"
"include(object/object)"
"_cpp_Object_constructor(lhs)"
"_cpp_Object_constructor(rhs)"
"_cpp_Object_constructor(subl)"
"_cpp_Object_constructor(subr)"
"_cpp_Object_add_members(\${lhs} member1)"
"_cpp_Object_add_members(\${rhs} member1)"
"_cpp_Object_add_members(\${subl} member2)"
"_cpp_Object_set_value(\${lhs} member1 \${subl})"
"_cpp_Object_set_value(\${rhs} member1 \${subr})"
"_cpp_Object_are_equal(test \${lhs} \${rhs})"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Same member objects are equal"
"include(object/object)"
"_cpp_Object_constructor(lhs)"
"_cpp_Object_constructor(rhs)"
"_cpp_Object_constructor(sub)"
"_cpp_Object_add_members(\${lhs} member1)"
"_cpp_Object_add_members(\${rhs} member1)"
"_cpp_Object_set_value(\${lhs} member1 \${sub})"
"_cpp_Object_set_value(\${rhs} member1 \${sub})"
"_cpp_Object_are_equal(test \${lhs} \${rhs})"
"_cpp_assert_true(test)"
)
