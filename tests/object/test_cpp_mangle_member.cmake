include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("mangle_member")

_cpp_add_test(
TITLE "Basic usage"
"include(object/mangle_member)"
"_cpp_Object_mangle_member(test member1)"
"_cpp_assert_equal(\"\${test}\" \"_cpp_member1\")"
)
