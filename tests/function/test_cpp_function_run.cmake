include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("function_run")

set(impl_file ${test_prefix}/${test_number}/impl.cmake)
file(WRITE ${impl_file}
"function(_cpp_fxn)
endfunction()
"
)

_cpp_add_test(
TITLE "Fails if there are returns and no prefix"
SHOULD_FAIL REASON "Prefix can not be empty for functions with returns."
"include(function/ctor)"
"include(function/run)"
"_cpp_Function_ctor(handle ${impl_file} RETURNS r1)"
"_cpp_Function_run(\${handle} \"\")"
)

set(impl_file ${test_prefix}/${test_number}/impl.cmake)
file(WRITE ${impl_file}
"function(_cpp_fxn)
if(\"\${ARGC}\" GREATER 0)
    _cpp_error(\"Passed arguments\")
endif()
endfunction()
"
)

_cpp_add_test(
TITLE "Call void(void)"
"include(function/ctor)"
"include(function/run)"
"_cpp_Function_ctor(handle ${impl_file} NO_KWARGS)"
"_cpp_Function_run(\${handle} \"\")"
)

set(impl_file ${test_prefix}/${test_number}/impl.cmake)
file(WRITE ${impl_file}
"function(_cpp_fxn _handle)
if(\"\${ARGC}\" GREATER 1)
    _cpp_error(\"Passed more than handle\")
endif()
if(NOT \"\${_handle}\" STREQUAL \"xxx\")
    _cpp_error(\"Passed wrong handle\")
endif()
endfunction()
"
)

_cpp_add_test(
TITLE "Call void(this, void)"
"include(function/ctor)"
"include(function/run)"
"_cpp_Function_ctor(handle ${impl_file} THIS xxx NO_KWARGS)"
"_cpp_Function_run(\${handle} \"\")"
)

set(impl_file ${test_prefix}/${test_number}/impl.cmake)
file(WRITE ${impl_file}
"function(_cpp_fxn _prefix)
if(\"\${ARGC}\" GREATER 1)
    _cpp_error(\"Passed more than prefix\")
endif()
set(\${_prefix}_r1 return1 PARENT_SCOPE)
set(\${_prefix}_r2 return2 PARENT_SCOPE)
set(\${_prefix}_r3 return3 PARENT_SCOPE)
endfunction()
"
)

_cpp_add_test(
TITLE "Call r1 r2 r3(void)"
"include(function/ctor)"
"include(function/run)"
"_cpp_Function_ctor(handle ${impl_file} NO_KWARGS RETURNS r1 r2 r3)"
"_cpp_Function_run(\${handle} \"test\")"
"_cpp_assert_equal(\${test_r1} return1)"
"_cpp_assert_equal(\${test_r2} return2)"
"_cpp_assert_equal(\${test_r3} return3)"
)

set(impl_file ${test_prefix}/${test_number}/impl.cmake)
file(WRITE ${impl_file}
"
include(kwargs/kwargs)
function(_cpp_fxn _kwargs)
if(\"\${ARGC}\" GREATER 1)
    _cpp_error(\"Passed more than kwargs\")
endif()
_cpp_Kwargs_kwarg_value(\${_kwargs} rv A_TOGGLE)
message(\"\${rv}\")
if(NOT \${rv})
_cpp_error(\"Wrong toggle value\")
endif()
endfunction()
"
)

_cpp_add_test(
TITLE "Call void(kwargs)"
"include(function/ctor)"
"include(function/run)"
"_cpp_Function_ctor(handle ${impl_file} TOGGLES A_TOGGLE)"
"_cpp_Function_run(\${handle} \"\" A_TOGGLE)"
)

set(impl_file ${test_prefix}/${test_number}/impl.cmake)
file(WRITE ${impl_file}
"
function(_cpp_fxn arg1 arg2)
if(\"\${ARGC}\" GREATER 2)
    _cpp_error(\"Passed more than two args\")
endif()
if(NOT \"\${arg1}\" STREQUAL  argument1)
    _cpp_error(\"Argument 1 is wrong\")
endif()
if(NOT \"\${arg2}\" STREQUAL  argument2)
    _cpp_error(\"Argument 2 is wrong\")
endif()
endfunction()
"
)

_cpp_add_test(
TITLE "Call void(arg1, arg2)"
"include(function/ctor)"
"include(function/run)"
"_cpp_Function_ctor(handle ${impl_file} NO_KWARGS)"
"_cpp_Function_run(\${handle} \"\" argument1 argument2)"
)

set(impl1_file ${test_prefix}/${test_number}/impl1.cmake)
file(WRITE ${impl1_file}
"
include(function/run)
function(_cpp_fxn prefix arg1)
    _cpp_Function_run(\${arg1} \${prefix})
    set(\${prefix}_rv \"\${\${prefix}_rv} World!\" PARENT_SCOPE)
endfunction()
"
)

set(impl2_file ${test_prefix}/${test_number}/impl2.cmake)
file(WRITE ${impl2_file}
"
function(_cpp_fxn prefix)
    set(\${prefix}_rv \"Hello\" PARENT_SCOPE)
endfunction()
"
)

_cpp_add_test(
TITLE "Nested functions"
"include(function/ctor)"
"include(function/run)"
"_cpp_Function_ctor(handle1 ${impl1_file} RETURNS rv NO_KWARGS)"
"_cpp_Function_ctor(handle2 ${impl2_file} RETURNS rv NO_KWARGS)"
"_cpp_Function_run(\${handle1} \"test\" \${handle2})"
"_cpp_assert_equal(\"\${test_rv}\" \"Hello World!\")"
)
