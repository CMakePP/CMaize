include(UnitTestHelpers)
include(cpp_checks)

_cpp_is_defined(TEST1 NOT_DEFINED_VARIABLE)
assert_false(TEST1)

set(DEFINED_VARIABLE "")
_cpp_is_defined(TEST2 DEFINED_VARIABLE)
assert_true(TEST2)

_cpp_is_empty(TEST3 NOT_DEFINED_VARIABLE)
assert_true(TEST3)

_cpp_is_empty(TEST4 DEFINED_VARIABLE)
assert_true(TEST4)

set(NON_EMPTY "Hello")
_cpp_is_empty(TEST5 NON_EMPTY)
assert_false(TEST5)
