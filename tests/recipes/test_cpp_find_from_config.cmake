include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_from_config")

set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Fails to find package w/o path"
"include(recipes/cpp_find_from_config)"
"_cpp_find_from_config(found dummy \"\" \"\" \"\")"
"_cpp_assert_false(found)"
)

_cpp_add_test(
TITLE "Finds package with path"
"include(recipes/cpp_find_from_config)"
"_cpp_find_from_config(found dummy \"\" \"\" ${src_dir}/install)"
"_cpp_assert_true(found)"
)

_cpp_add_test(
TITLE "Saves config file to helper target"
"include(recipes/cpp_find_from_config)"
"add_library(_cpp_dummy_External INTERFACE)"
"_cpp_find_from_config(found dummy \"\" \"\" ${src_dir}/install)"
"_cpp_assert_true(found)"
"get_target_property(file _cpp_dummy_External INTERFACE_INCLUDE_DIRECTORIES)"
"_cpp_assert_equal("
"   \"\${file}\" \"set(dummy_DIR ${src_dir}/install/share/cmake/dummy)\""
")"
)
