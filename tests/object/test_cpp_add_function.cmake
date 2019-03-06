include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("add_function")

set(impl_file ${test_prefix}/impl.cmake)
file(WRITE ${impl_file} "function(_cpp_Object_a_fxn)\nendfunction()")

_cpp_add_test(
TITLE "Error if name is empty"
SHOULD_FAIL REASON "Name shouldn't be empty"
"include(object/object)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_add_function(\${handle} \"\" \"${impl_file}\")"
)

_cpp_add_test(
TITLE "Error if path is empty"
SHOULD_FAIL REASON "Path shouldn't be empty"
"include(object/object)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_add_function(\${handle} \"a_fxn\" \"\")"
)

_cpp_add_test(
TITLE "Error if path does not exist"
SHOULD_FAIL REASON "Path not/a/path does not exist"
"include(object/object)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_add_function(\${handle} \"a_fxn\" \"not/a/path\")"
)

_cpp_add_test(
TITLE "Error if function already exists"
SHOULD_FAIL REASON "Overload already exists"
"include(object/object)"
"include(object/impl/mangle_function_name)"
"_cpp_Object_ctor(handle)"
"_cpp_mangle_function_name(mn Object a_fxn)"
"_cpp_Object_add_members(\${handle} \${mn})"
"_cpp_Object_add_function(\${handle} a_fxn \"${impl_file}\")"
)

_cpp_add_test(
TITLE "Basic usage"
"include(object/object)"
"include(object/impl/mangle_function_name)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_add_function(\${handle} a_fxn \"${impl_file}\")"
"_cpp_mangle_function_name(mn Object a_fxn)"
"_cpp_mangle_function_name(base \"\" a_fxn)"
"_cpp_Object_get_value(\${handle} test \${base})"
"_cpp_assert_equal(\"\${test}\" \"\${mn}\")"
)

_cpp_add_test(
TITLE "Override function"
"include(object/object)"
"include(object/impl/mangle_function_name)"
"_cpp_Object_ctor(handle)"
"_cpp_mangle_function_name(base \"\" a_fxn)"
"_cpp_Object_add_function(\${handle} a_fxn \"${impl_file}\")"
"_cpp_Object_set_type(\${handle} new_type)"
"_cpp_Object_add_function(\${handle} a_fxn \"${impl_file}\")"
"_cpp_mangle_function_name(mn1 Object a_fxn)"
"_cpp_mangle_function_name(mn2 new_type a_fxn)"
"_cpp_Object_get_value(\${handle} test \${base})"
"set(corr \${mn1} \${mn2})"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
)
