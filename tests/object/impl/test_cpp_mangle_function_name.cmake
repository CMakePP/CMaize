include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("mangle_function_name")

_cpp_add_test(
TITLE "Basic usage"
"include(object/impl/mangle_function_name)"
"include(object/ctor)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_mangle_function_name(\${handle} test a_fxn)"
"_cpp_assert_equal(\"\${test}\" _cpp_Object_a_fxn)"
)
