include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("serialize_object")

set(q "\\\"")
set(common "${q}_cpp_type${q} : ${q}Object${q} , ")
set(common "${common}${q}_cpp_member_fxn_list${q} : ${q}${q}")

_cpp_add_test(
TITLE "Empty object"
"include(serialization/serialize_object)"
"include(object/object)"
"_cpp_Object_ctor(t)"
"_cpp_serialize_object(test \${t})"
"_cpp_assert_equal(\"\${test}\" \"{ ${common} }\")"
)

_cpp_add_test(
TITLE "Object with member set to empty value"
"include(serialization/serialize_object)"
"include(object/object)"
"_cpp_Object_ctor(t)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_serialize_object(test \${t})"
"_cpp_assert_equal("
"   \"\${test}\""
"   \"{ ${common} , \\\"member\\\" : \\\"\\\" }\""
")"
)

_cpp_add_test(
TITLE "Object with member set to string"
"include(serialization/serialize_object)"
"include(object/object)"
"_cpp_Object_ctor(t)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_Object_set_value(\${t} member value)"
"_cpp_serialize_object(test \${t})"
"_cpp_assert_equal("
"   \"\${test}\""
"   \"{ ${common} , \\\"member\\\" : \\\"value\\\" }\""
")"
)

_cpp_add_test(
TITLE "Object with member set to list"
"include(serialization/serialize_object)"
"include(object/object)"
"_cpp_Object_ctor(t)"
"_cpp_Object_add_members(\${t} member)"
"set(a_list one two)"
"_cpp_Object_set_value(\${t} member \"\${a_list}\")"
"_cpp_serialize_object(test \${t})"
"_cpp_assert_equal("
"   \"\${test}\""
"   \"{ ${common} , \\\"member\\\" : [ \\\"one\\\" , \\\"two\\\" ] }\""
")"
)

_cpp_add_test(
TITLE "Object with member set to object"
"include(serialization/serialize_object)"
"include(object/object)"
"_cpp_Object_ctor(t)"
"_cpp_Object_ctor(u)"
"_cpp_Object_add_members(\${t} member)"
"_cpp_Object_set_value(\${t} member \"\${u}\")"
"_cpp_serialize_object(test \${t})"
"_cpp_assert_equal("
"   \"\${test}\""
"   \"{ ${common} , \\\"member\\\" : { ${common} } }\""
")"
)
