include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_checks)

_cpp_is_defined(TEST1 NOT_DEFINED_VARIABLE)
_cpp_assert_false(TEST1)

set(DEFINED_VARIABLE "")
_cpp_is_defined(TEST2 DEFINED_VARIABLE)
_cpp_assert_true(TEST2)

_cpp_is_empty(TEST3 NOT_DEFINED_VARIABLE)
_cpp_assert_true(TEST3)

_cpp_is_empty(TEST4 DEFINED_VARIABLE)
_cpp_assert_true(TEST4)

set(NON_EMPTY "Hello")
_cpp_is_empty(TEST5 NON_EMPTY)
_cpp_assert_false(TEST5)

_cpp_valid(TEST6 NOT_DEFINED_VARIABLE)
_cpp_assert_false(TEST6)

_cpp_valid(TEST7 DEFINED_VARIABLE)
_cpp_assert_false(TEST7)

_cpp_valid(TEST8 NON_EMPTY)
_cpp_assert_true(TEST8)

set(STRING_TRUE "TRUE")
_cpp_assert_true(STRING_TRUE)

set(STRING_FALSE "FALSE")
_cpp_assert_false(STRING_FALSE)

_cpp_assert_str_equal(${STRING_FALSE} "FALSE")
