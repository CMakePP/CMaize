include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("serialize_list")

_cpp_add_test(
TITLE "Empty list"
"include(serialization/serialize_list)"
"_cpp_serialize_list(test \"\")"
"_cpp_assert_equal(\"\${test}\" \"[ ]\")"
)

_cpp_add_test(
TITLE "Normal list"
"include(serialization/serialize_list)"
"set(a_list one two)"
"_cpp_serialize_list(test \"\${a_list}\")"
"_cpp_assert_equal(\"\${test}\" \"[ \\\"one\\\" , \\\"two\\\" ]\")"
)

#I won't lie, this was trial and error to figure out how many escapes I needed
#
set(escape1 "\\\\\\\\\\\\\\\\;")
set(escape2 "\\\\\\\\\\\\\\\\\\\\;")
_cpp_add_test(
TITLE "Nested list"
"include(serialization/serialize_list)"
"set(a_list \"one${escape2}two${escape1}three${escape2}four\")"
"_cpp_serialize_list(test \"\${a_list}\")"
"_cpp_assert_equal("
"   \"\${test}\""
"\"[ [ \\\"one\\\" , \\\"two\\\" ] , [ \\\"three\\\" , \\\"four\\\" ] ]\""
")"
)
