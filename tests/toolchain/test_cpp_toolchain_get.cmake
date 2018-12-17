include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("toolchain_get")

_cpp_add_test(
TITLE "Variable that exists"
CONTENTS
    "include(toolchain/cpp_toolchain_get)"
    "_cpp_toolchain_get(output ${CMAKE_TOOLCHAIN_FILE} CMAKE_CXX_COMPILER)"
    "_cpp_assert_equal(\${output} \"${CMAKE_CXX_COMPILER}\")"
)

_cpp_add_test(
TITLE "Variable that does not exist"
SHOULD_FAIL REASON "does not contain variable:"
CONTENTS
    "include(toolchain/cpp_toolchain_get)"
    "_cpp_toolchain_get(output ${CMAKE_TOOLCHAIN_FILE} FAKE_VARIABLE)"
)
