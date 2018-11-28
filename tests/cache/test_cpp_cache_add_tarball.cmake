include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_build_env("cache_add_tarball")

_cpp_cache_tarball_path(no_version ${test_prefix} dummy "")
_cpp_cache_tarball_path(version ${test_prefix} dummy 1.0)
_cpp_cache_get_recipe_path(recipe ${test_prefix} dummy)

file(
    WRITE ${recipe}
"function(_cpp_get_recipe location version)
    file(WRITE \${location} \"Hi\")
endfunction()"
)

_cpp_add_test(
TITLE "Version usage"
CONTENTS
    "include(cache/cache_tarball)"
    "_cpp_assert_does_not_exist(${version})"
    "_cpp_cache_add_tarball(${test_prefix} dummy 1.0)"
    "_cpp_assert_exists(${version})"
)

_cpp_add_test(
TITLE "Repeated version usage is okay if same tarball"
CONTENTS
    "include(cache/cache_tarball)"
    "_cpp_assert_exists(${version})"
    "_cpp_cache_add_tarball(${test_prefix} dummy 1.0)"
    "_cpp_assert_exists(${version})"
)

_cpp_add_test(
TITLE "Non-Version Usage"
CONTENTS
    "include(cache/cache_tarball)"
    "_cpp_assert_does_not_exist(${no_version})"
    "_cpp_cache_add_tarball(${test_prefix} dummy \"\")"
    "_cpp_assert_exists(${no_version})"
)

_cpp_add_test(
TITLE "Repeated Non-Version Usage is okay if same tarball"
CONTENTS
    "include(cache/cache_tarball)"
    "_cpp_assert_exists(${no_version})"
    "_cpp_cache_add_tarball(${test_prefix} dummy \"\")"
    "_cpp_assert_exists(${no_version})"
)

#Change get-recipe so we get different "tarballs"
file(
    WRITE ${recipe}
"function(_cpp_get_recipe location version)
    file(WRITE \${location} \"Bye\")
endfunction()"
)

_cpp_add_test(
TITLE "Repeated version usage is fails if different tarballs"
SHOULD_FAIL REASON "are not the same."
CONTENTS
    "include(cache/cache_tarball)"
    "_cpp_assert_exists(${version})"
    "_cpp_cache_add_tarball(${test_prefix} dummy 1.0)"
)

_cpp_add_test(
TITLE "Repeated non-version usage is okay if different tarballs"
CONTENTS
    "include(cache/cache_tarball)"
    "_cpp_assert_exists(${no_version})"
    "_cpp_cache_add_tarball(${test_prefix} dummy \"\")"
    "_cpp_assert_file_contains(\"Bye\" ${no_version})"
)
