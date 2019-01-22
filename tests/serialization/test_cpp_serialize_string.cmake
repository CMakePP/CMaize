include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("serialize_string")

_cpp_add_test(
TITLE "Can serialize a basic string"
"include(serialization/serialize_string)"
"_cpp_serialize_string(test \"hello world\")"
"_cpp_assert_equal(\"\${test}\" \"\\\"hello world\\\"\")"
)

_cpp_add_test(
TITLE "Can serialize null string"
"include(serialization/serialize_string)"
"_cpp_serialize_string(test \"\")"
"_cpp_assert_equal(\"\${test}\" \"\\\"\\\"\")"
)
