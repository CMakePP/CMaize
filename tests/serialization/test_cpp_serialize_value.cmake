include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("serialize_value")

_cpp_add_test(
TITLE "Can serialize a basic string"
"include(serialization/serialize_value)"
"_cpp_serialize_value(test \"hello world\")"
"_cpp_assert_equal(\"\${test}\" \"\\\"hello world\\\"\")"
)

_cpp_add_test(
TITLE "Can serialize null string"
"include(serialization/serialize_value)"
"_cpp_serialize_value(test \"\")"
"_cpp_assert_equal(\"\${test}\" \"\\\"\\\"\")"
)

_cpp_add_test(
TITLE "Normal list"
"include(serialization/serialize_value)"
"set(a_list one two)"
"_cpp_serialize_value(test \"\${a_list}\")"
"_cpp_assert_equal(\"\${test}\" \"[ \\\"one\\\" , \\\"two\\\" ]\")"
)

set(escape1 "\\\\\\\\\\\\\\\\\\\\;")
set(escape2 "\\\\\\\\\\\\\\\\\\\\\\\;")
_cpp_add_test(
TITLE "Nested list"
"include(serialization/serialize_value)"
"set(a_list \"one${escape2}two${escape1}three${escape2}four\")"
"_cpp_serialize_value(test \"\${a_list}\")"
"_cpp_assert_equal("
"   \"\${test}\""
"\"[ [ \\\"one\\\" , \\\"two\\\" ] , [ \\\"three\\\" , \\\"four\\\" ] ]\""
")"
)
