include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("deserialize_object")

_cpp_add_test(
TITLE "Empty object"
"include(serialization/deserialize_object)"
"include(object/object)"
"set(buffer \" }\")"
"_cpp_Object_constructor(corr)"
"_cpp_deserialize_object(obj buffer)"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
"_cpp_Object_are_equal(test \${obj} \${corr})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Object with member set to empty value"
"include(serialization/deserialize_object)"
"include(object/object)"
"set(buffer \" \\\"member\\\" : \\\"\\\" }\")"
"_cpp_Object_constructor(corr)"
"_cpp_Object_add_members(\${corr} member)"
"_cpp_deserialize_object(obj buffer)"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
"_cpp_Object_are_equal(test \${obj} \${corr})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Object with member set to string"
"include(serialization/deserialize_object)"
"include(object/object)"
"set(buffer \" \\\"member\\\" : \\\"value\\\" }\")"
"_cpp_Object_constructor(corr)"
"_cpp_Object_add_members(\${corr} member)"
"_cpp_Object_set_value(\${corr} member value)"
"_cpp_deserialize_object(obj buffer)"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
"_cpp_Object_are_equal(test \${obj} \${corr})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Object with member set to list"
"include(serialization/deserialize_object)"
"include(object/object)"
"set(buffer \" \\\"member\\\" : [ \\\"one\\\" , \\\"two\\\" ] }\")"
"_cpp_Object_constructor(corr)"
"_cpp_Object_add_members(\${corr} member)"
"set(a_list one two)"
"_cpp_Object_set_value(\${corr} member \"\${a_list}\")"
"_cpp_deserialize_object(obj buffer)"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
"_cpp_Object_are_equal(test \${obj} \${corr})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Object with member set to object"
"include(serialization/deserialize_object)"
"include(object/object)"
"set(buffer \" \\\"member\\\" : { } }\")"
"_cpp_Object_constructor(corr)"
"_cpp_Object_constructor(t)"
"_cpp_Object_add_members(\${corr} member)"
"_cpp_Object_set_value(\${corr} member \"\${t}\")"
"_cpp_deserialize_object(obj buffer)"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
"_cpp_Object_are_equal(test \${obj} \${corr})"
"_cpp_assert_true(test)"
)
