include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("sanitize_version")

_cpp_add_test(
TITLE "Empty version"
CONTENTS
    "include(dependency/cpp_sanitize_version)"
    "_cpp_sanitize_version(output \"\")"
    "_cpp_assert_false(output)"
)

_cpp_add_test(
TITLE  "Good already"
CONTENTS
    "include(dependency/cpp_sanitize_version)"
    "_cpp_sanitize_version(output 1.2.3)"
    "_cpp_assert_equal(\${output} 1.2.3)"
)

_cpp_add_test(
TITLE  "Removes v"
CONTENTS
    "include(dependency/cpp_sanitize_version)"
    "_cpp_sanitize_version(output v1.2.3)"
    "_cpp_assert_equal(\${output} 1.2.3)"
)
