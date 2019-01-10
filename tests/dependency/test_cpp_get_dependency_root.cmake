include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_dependency_root")

_cpp_add_test(
TITLE "No target"
"include(dependency/cpp_get_dependency_root)"
"_cpp_get_dependency_root(test not_a_target)"
"_cpp_assert_equal(\${test} \"test-NOTFOUND\")"
)

_cpp_add_test(
TITLE "XXX_ROOT"
"include(dependency/cpp_get_dependency_root)"
"add_library(_cpp_dummy_External INTERFACE)"
"set_target_properties("
"   _cpp_dummy_External"
"   PROPERTIES INTERFACE_INCLUDE_DIRECTORIES"
"   \"dummy_ROOT ${test_prefix}\""
")"
"_cpp_get_dependency_root(test dummy)"
"_cpp_assert_equal(\${test} \"${test_prefix}\")"
)

_cpp_add_test(
TITLE "XXX_DIR"
"include(dependency/cpp_get_dependency_root)"
"add_library(_cpp_dummy_External INTERFACE)"
"set_target_properties("
"   _cpp_dummy_External"
"   PROPERTIES INTERFACE_INCLUDE_DIRECTORIES"
"   \"dummy_DIR ${test_prefix}\""
")"
"_cpp_get_dependency_root(test dummy)"
"_cpp_assert_equal(\${test} \"test-NOTFOUND\")"
)
