include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("is_not_target")

_cpp_add_test(
TITLE "False if target"
"include(logic/is_not_target)"
"add_library(dummy INTERFACE)"
"_cpp_is_not_target(test dummy)"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "True if not target"
"include(logic/is_not_target)"
"_cpp_is_not_target(test dummy)"
"_cpp_assert_true(test)"
)
