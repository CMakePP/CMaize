include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("deserialize_value")

_cpp_add_test(
TITLE "Can deserialize null string"
"include(serialization/deserialize_value)"
"set(buffer \"\\\"\\\"\")"
"_cpp_deserialize_value(test buffer)"
"_cpp_assert_equal(\"\${test}\" \"\")"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
)

_cpp_add_test(
TITLE "Can deserialize a basic string"
"include(serialization/deserialize_value)"
"set(buffer \"\\\"hello world\\\"\")"
"_cpp_deserialize_value(test buffer)"
"_cpp_assert_equal(\"\${test}\" \"hello world\")"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
)

#For some reason the CMakeLists.txt gets screwed up if there's
#not two square brackets in the same string...

_cpp_add_test(
TITLE "Empty list"
"include(serialization/deserialize_value)"
"set(buffer \"[ ]\")"
"_cpp_deserialize_value(test buffer)"
"_cpp_assert_equal(\"\${test}\" \"\")"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
)

_cpp_add_test(
TITLE "Normal list"
"include(serialization/deserialize_value)"
"set(buffer \"[ \\\"one\\\" , \\\"two\\\" ]\")"
"set(a_list one two)"
"_cpp_deserialize_value(test buffer)"
"_cpp_assert_equal(\"\${test}\" \"\${a_list}\")"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
)

set(escape1 "\\\\\\\\\\\\\\\\;")
set(escape2 "\\\\\\\\\\\\\\\\\\\\;")
_cpp_add_test(
TITLE "Nested list"
"include(serialization/deserialize_value)"
"set(corr \"one${escape2}two${escape1}three${escape2}four\")"
"set("
"   buffer"
"   \"[ [ \\\"one\\\" , \\\"two\\\" ] , [ \\\"three\\\" , \\\"four\\\" ] ]\""
")"
"_cpp_deserialize_value(test buffer)"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
)

_cpp_add_test(
TITLE "Empty object"
"include(serialization/deserialize_value)"
"include(object/object)"
"set(buffer \"{ }\")"
"_cpp_Object_constructor(corr)"
"_cpp_deserialize_value(obj buffer)"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
"_cpp_Object_are_equal(test \${obj} \${corr})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Object with member set to empty value"
"include(serialization/deserialize_value)"
"include(object/object)"
"set(buffer \"{ \\\"member\\\" : \\\"\\\" }\")"
"_cpp_Object_constructor(corr)"
"_cpp_Object_add_members(\${corr} member)"
"_cpp_deserialize_value(obj buffer)"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
"_cpp_Object_are_equal(test \${obj} \${corr})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Object with member set to string"
"include(serialization/deserialize_value)"
"include(object/object)"
"set(buffer \"{ \\\"member\\\" : \\\"value\\\" }\")"
"_cpp_Object_constructor(corr)"
"_cpp_Object_add_members(\${corr} member)"
"_cpp_Object_set_value(\${corr} member value)"
"_cpp_deserialize_value(obj buffer)"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
"_cpp_Object_are_equal(test \${obj} \${corr})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Object with member set to list"
"include(serialization/deserialize_value)"
"include(object/object)"
"set(buffer \"{ \\\"member\\\" : [ \\\"one\\\" , \\\"two\\\" ] }\")"
"_cpp_Object_constructor(corr)"
"_cpp_Object_add_members(\${corr} member)"
"set(a_list one two)"
"_cpp_Object_set_value(\${corr} member \"\${a_list}\")"
"_cpp_deserialize_value(obj buffer)"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
"_cpp_Object_are_equal(test \${obj} \${corr})"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Object with member set to object"
"include(serialization/deserialize_value)"
"include(object/object)"
"set(buffer \"{ \\\"member\\\" : { } }\")"
"_cpp_Object_constructor(corr)"
"_cpp_Object_constructor(t)"
"_cpp_Object_add_members(\${corr} member)"
"_cpp_Object_set_value(\${corr} member \"\${t}\")"
"_cpp_deserialize_value(obj buffer)"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
"_cpp_Object_are_equal(test \${obj} \${corr})"
"_cpp_assert_true(test)"
)
