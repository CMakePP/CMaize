include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_test_env("cache_source")

#Make some "tarballs" (we never check them)
_cpp_cache_tarball_path(no_version ${test_prefix} dummy "")
_cpp_cache_tarball_path(version ${test_prefix} dummy 1.0)
file(WRITE ${version} "Hi")
file(WRITE ${no_version} "Hi")
_cpp_cache_source_path(version ${test_prefix} dummy "")
file(WRITE ${version} "Hi")


_cpp_add_test(
TITLE "Retrieve versioned source"
CONTENTS
    "include(cache/cache_source)"
    "_cpp_cache_source(output ${test_prefix} dummy 1.0)"
    "_cpp_assert_equal(\${output} ${version})"
)

_cpp_add_test(
TITLE "Retrieve unversioned source"
CONTENTS
    "include(cache/cache_source)"
    "_cpp_cache_source(output ${test_prefix} dummy \"\")"
    "_cpp_assert_equal(\${output} ${version})"
)

_cpp_add_test(
TITLE "Fails if source DNE"
SHOULD_FAIL REASON "does not exist."
CONTENTS
    "include(cache/cache_source)"
    "_cpp_cache_source(output ${test_prefix} dummy 1.1)"
)
