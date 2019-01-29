include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("handle_target_vars")

_cpp_add_test(
TITLE "Does nothing if target is present"
"include(find_recipe/handle_target_vars)"
"add_library(dummy INTERFACE IMPORTED)"
"set(dummy_INCLUDE_DIRS a/path)"
"_cpp_handle_target_vars(dummy)"
"get_target_property(test dummy INTERFACE_INCLUDE_DIRECTORIES)"
"_cpp_assert_equal(\"\${test}\" \"test-NOTFOUND\")"
)

_cpp_add_test(
TITLE "Makes and populates includes"
"include(find_recipe/handle_target_vars)"
"set(dummy_INCLUDE_DIRS a/path)"
"_cpp_is_target(test dummy)"
"_cpp_assert_false(test)"
"_cpp_handle_target_vars(dummy)"
"_cpp_is_target(test dummy)"
"_cpp_assert_true(test)"
"get_target_property(test dummy INTERFACE_INCLUDE_DIRECTORIES)"
"_cpp_assert_equal(\"\${test}\" \"\${CMAKE_CURRENT_SOURCE_DIR}/a/path\")"
)

_cpp_add_test(
TITLE "Makes and populates libraries"
"include(find_recipe/handle_target_vars)"
"set(dummy_LIBRARIES a/path)"
"_cpp_handle_target_vars(dummy)"
"get_target_property(test dummy INTERFACE_LINK_LIBRARIES)"
"_cpp_assert_equal(\"\${test}\" \"a/path\")"
)
