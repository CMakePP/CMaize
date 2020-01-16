include_guard()

macro(cpp_add_tests _at_name)
    include(CTest)
    cpp_add_executable("${_at_name}" ${ARGN})
    add_test(NAME "${_at_name}" COMMAND "${_at_name}")
endmacro()
