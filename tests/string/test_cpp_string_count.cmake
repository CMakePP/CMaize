include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("string_count")

_cpp_add_test(
TITLE "No matches"
"include(string/cpp_string_count)"
"_cpp_string_count(return not_present \"Hello World\")"
"_cpp_assert_equal(\${return} 0)"
)

_cpp_add_test(
TITLE "Single match"
"include(string/cpp_string_count)"
"_cpp_string_count(return Hello \"Hello World\")"
"_cpp_assert_equal(\${return} 1)"
)

_cpp_add_test(
TITLE "Match as part of word"
"include(string/cpp_string_count)"
"_cpp_string_count(return Hello \"Is there a space in HelloWorld?\")"
"_cpp_assert_equal(\${return} 1)"
)

_cpp_add_test(
TITLE "Multiple matches"
"include(string/cpp_string_count)"
"_cpp_string_count(return Hello \"Hello. I say HelloWorld, not Hello World\")"
"_cpp_assert_equal(\${return} 3)"
)
