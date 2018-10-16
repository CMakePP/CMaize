include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_checks)
include(cpp_assert)


set(EMPTY_STRING "")
set(BOOL_VAR TRUE)
set(IDENTIFIER_VAR CMAKE_C_COMPILER)
set(STRING_VAR "A value")

################################################################################
# Test _cpp_is_defined / _cpp_is_not_defined
################################################################################

_cpp_is_defined(TEST1 NOT_DEFINED_VARIABLE)
_cpp_assert_false(TEST1)

_cpp_is_not_defined(TEST2 NOT_DEFINED_VARIABLE)
_cpp_assert_true(TEST2)

foreach(def_var EMPTY_STRING BOOL_VAR IDENTIFIER_VAR STRING_VAR)
    _cpp_is_defined(TEST3 ${def_var})
    _cpp_assert_true(TEST3)

    _cpp_is_not_defined(TEST4 ${def_var})
    _cpp_assert_false(TEST4)
endforeach()

################################################################################
# Test _cpp_is_empty / _cpp_non_empty
################################################################################

_cpp_is_empty(TEST1 NOT_DEFINED_VARIABLE)
_cpp_assert_true(TEST1)

_cpp_non_empty(TEST2 NON_DEFINED_VARIABLE)
_cpp_assert_false(TEST2)

_cpp_is_empty(TEST3 EMPTY_STRING)
_cpp_assert_true(TEST3)

_cpp_non_empty(TEST4 EMPTY_STRING)
_cpp_assert_false(TEST4)


foreach(non_empty BOOL_VAR IDENTIFIER_VAR STRING_VAR)
    _cpp_is_empty(TEST5 ${non_empty})
    _cpp_assert_false(TEST5)

    _cpp_non_empty(TEST6 ${non_empty})
    _cpp_assert_true(TEST6)
endforeach()

################################################################################
# Test _cpp_contains / _cpp_does_not_contain
################################################################################

foreach(string "hello world" "**hello**" "   hello world")
    _cpp_contains(TEST1 "hello" "${string}")
    _cpp_assert_true(TEST1)

    _cpp_does_not_contain(TEST2 "hello" "${string}")
    _cpp_assert_false(TEST2)
endforeach()

foreach(string "h world" "hell o world" "**hell*o*")
    _cpp_contains(TEST3 "hello" "${string}")
    _cpp_assert_false(TEST3)

    _cpp_does_not_contain(TEST4 "hello" "${string}")
    _cpp_assert_true(TEST4)
endforeach()
