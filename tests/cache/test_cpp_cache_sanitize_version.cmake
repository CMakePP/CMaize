include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("cache_sanitize_version")

_cpp_add_test(
TITLE "User provided version"
CONTENTS
    "include(cache/cache_sanitize_version)"
    "_cpp_cache_sanitize_version(output 1.0)"
    "_cpp_assert_equal(\${output} \"1.0\")"
)

_cpp_add_test(
TITLE "No version"
CONTENTS
    "include(cache/cache_sanitize_version)"
    "_cpp_cache_sanitize_version(output \"\")"
    "_cpp_assert_equal(\${output} \"latest\")"
)
