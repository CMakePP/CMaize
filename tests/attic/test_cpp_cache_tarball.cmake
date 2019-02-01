include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_test_env("cache_tarball")

#Make some "tarballs" (we never check them)
_cpp_cache_tarball_path(no_version ${test_prefix} dummy "")
_cpp_cache_tarball_path(version ${test_prefix} dummy 1.0)
file(WRITE ${version} "Hi")
file(WRITE ${no_version} "Bye")

_cpp_add_test(
TITLE "Retrieve versioned tarball"
CONTENTS
    "include(cache/cache_tarball)"
    "_cpp_cache_tarball(output ${test_prefix} dummy 1.0)"
    "_cpp_assert_equal(\${output} ${version})"
)

_cpp_add_test(
TITLE "Retrieve unversioned tarball"
CONTENTS
    "include(cache/cache_tarball)"
    "_cpp_cache_tarball(output ${test_prefix} dummy \"\")"
    "_cpp_assert_equal(\${output} ${no_version})"
)

_cpp_add_test(
TITLE "Fails if tarball DNE"
SHOULD_FAIL REASON "does not exist."
CONTENTS
    "include(cache/cache_tarball)"
    "_cpp_cache_tarball(output ${test_prefix} dummy 1.1)"
)


