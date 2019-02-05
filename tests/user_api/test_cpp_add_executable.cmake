include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("add_executable")

set(root ${test_prefix}/${test_number})
_cpp_dummy_cxx_executable(${root})

_cpp_add_test(
TITLE "Basic executable"
"include(user_api/cpp_add_executable)"
"cpp_add_executable(dummy SOURCES ${root}/main.cpp)"
"get_target_property(test dummy SOURCES)"
"_cpp_assert_equal(\"\${test}\" \"${root}/main.cpp\")"
)
