include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("deserialize_string")

_cpp_add_test(
TITLE "Can deserialize null string"
"include(serialization/deserialize_string)"
"set(buffer \"\\\"\")"
"_cpp_deserialize_string(test buffer)"
"_cpp_assert_equal(\"\${test}\" \"\")"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
)

_cpp_add_test(
TITLE "Can deserialize a basic string"
"include(serialization/deserialize_string)"
"set(buffer \"hello world\\\"\")"
"_cpp_deserialize_string(test buffer)"
"_cpp_assert_equal(\"\${test}\" \"hello world\")"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
)

_cpp_add_test(
TITLE "Can deserialize a basic string starting with a space"
"include(serialization/deserialize_string)"
"set(buffer \" hello world\\\"\")"
"_cpp_deserialize_string(test buffer)"
"_cpp_assert_equal(\"\${test}\" \" hello world\")"
"_cpp_assert_equal(\"\${buffer}\" \"\")"
)
