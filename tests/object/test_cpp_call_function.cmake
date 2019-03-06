include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("call_function")

set(impl1_file ${test_prefix}/impl1.cmake)
file(
    WRITE ${impl1_file}
"
function(_cpp_fxn _handle _prefix arg1)
    set(\${_prefix}_rv \"Hello \${arg1} from impl1\" PARENT_SCOPE)
endfunction()
"
)
set(impl2_file ${test_prefix}/impl2.cmake)
file(
    WRITE ${impl2_file}
"
function(_cpp_fxn _handle _prefix arg1)
    set(\${_prefix}_rv \"Hello \${arg1} from impl2\" PARENT_SCOPE)
endfunction()
"
)

_cpp_add_test(
TITLE "Fails if function name is empty"
SHOULD_FAIL REASON "Function name can't be empty."
"include(object/object)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_call(\${handle} \"\" \"\")"
)

_cpp_add_test(
TITLE "Basic usage"
"include(object/object)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_add_function(\${handle} a_fxn ${impl1_file} NO_KWARGS RETURNS rv)"
"_cpp_Object_call(\${handle} test a_fxn there)"
"_cpp_assert_equal(\"\${test_rv}\" \"Hello there from impl1\")"
)

_cpp_add_test(
TITLE "Virtual usage"
"include(object/object)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_add_function(\${handle} a_fxn ${impl1_file} NO_KWARGS RETURNS rv)"
"_cpp_Object_set_type(\${handle} derived)"
"_cpp_Object_add_function(\${handle} a_fxn ${impl2_file} NO_KWARGS RETURNS rv)"
"_cpp_Object_call(\${handle} test a_fxn there)"
"_cpp_assert_equal(\"\${test_rv}\" \"Hello there from impl2\")"
)
