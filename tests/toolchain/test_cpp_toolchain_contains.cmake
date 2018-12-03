include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("toolchain_contains")

_cpp_add_test(
TITLE "Variable that exists"
CONTENTS
    "include(toolchain/cpp_toolchain_contains)"
    "_cpp_toolchain_contains(output ${CMAKE_TOOLCHAIN_FILE} CMAKE_CXX_COMPILER)"
    "_cpp_assert_true(\${output})"
)

_cpp_add_test(
TITLE "Variable that does not exist"
CONTENTS
    "include(toolchain/cpp_toolchain_contains)"
    "_cpp_toolchain_contains(output ${CMAKE_TOOLCHAIN_FILE} FAKE_VARIABLE)"
    "_cpp_assert_false(\${output})"
)
