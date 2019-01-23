include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("serialize_object")

_cpp_add_test(
TITLE "Empty object"
"include(serialization/serialize_object)"
"include(object/object)"
"_cpp_Object_constructor(t)"
"_cpp_serialize_object(test \${t})"
"_cpp_assert_equal(\"\${test}\" \"{ }\")"
)

_cpp_add_test(
TITLE "Object with member set to empty value"
"include(serialization/serialize_object)"
"include(object/object)"
"_cpp_Object_constructor(t)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_serialize_object(test \${t})"
"_cpp_assert_equal("
"   \"\${test}\""
"   \"{ \\\"member\\\" : \\\"\\\" }\""
")"
)

_cpp_add_test(
TITLE "Object with member set to string"
"include(serialization/serialize_object)"
"include(object/object)"
"_cpp_Object_constructor(t)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_Object_set_value(\${t} member value)"
"_cpp_serialize_object(test \${t})"
"_cpp_assert_equal("
"   \"\${test}\""
"   \"{ \\\"member\\\" : \\\"value\\\" }\""
")"
)

_cpp_add_test(
TITLE "Object with member set to list"
"include(serialization/serialize_object)"
"include(object/object)"
"_cpp_Object_constructor(t)"
"_cpp_Object_add_members(\${t} member)"
"set(a_list one two)"
"_cpp_Object_set_value(\${t} member \"\${a_list}\")"
"_cpp_serialize_object(test \${t})"
"_cpp_assert_equal("
"   \"\${test}\""
"   \"{ \\\"member\\\" : [ \\\"one\\\" , \\\"two\\\" ] }\""
")"
)

_cpp_add_test(
TITLE "Object with member set to object"
"include(serialization/serialize_object)"
"include(object/object)"
"_cpp_Object_constructor(t)"
"_cpp_Object_constructor(u)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_Object_set_value(\${t} member \"\${u}\")"
"_cpp_serialize_object(test \${t})"
"_cpp_assert_equal("
"   \"\${test}\""
"   \"{ \\\"member\\\" : { } }\""
")"
)
