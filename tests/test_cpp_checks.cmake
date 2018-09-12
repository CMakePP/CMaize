include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_checks)
include(cpp_assert)


set(EMPTY_STRING "")
set(BOOL_VAR TRUE)
set(IDENTIFIER_VAR CMAKE_C_COMPILER)
set(STRING_VAR "A value")

_cpp_is_defined(TEST1 NOT_DEFINED_VARIABLE)
_cpp_assert_false(TEST1)

foreach(def_var EMPTY_STRING BOOL_VAR IDENTIFIER_VAR STRING_VAR)
    _cpp_is_defined(TEST2 ${def_var})
    _cpp_assert_true(TEST2)
endforeach()

_cpp_is_empty(TEST3 NOT_DEFINED_VARIABLE)
_cpp_assert_true(TEST3)

_cpp_non_empty(TEST4 NON_DEFINED_VARIABLE)
_cpp_assert_false(TEST4)

_cpp_is_empty(TEST5 EMPTY_STRING)
_cpp_assert_true(TEST5)

_cpp_non_empty(TEST6 EMPTY_STRING)
_cpp_assert_false(TEST6)


foreach(non_empty BOOL_VAR IDENTIFIER_VAR STRING_VAR)
    _cpp_is_empty(TEST7 ${non_empty})
    _cpp_assert_false(TEST7)

    _cpp_non_empty(TEST8 ${non_empty})
    _cpp_assert_true(TEST8)
endforeach()
