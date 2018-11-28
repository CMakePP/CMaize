include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_build_env("cache_add_build_recipe")

_cpp_cache_build_recipe_path(version ${test_prefix} dummy 1.0)
_cpp_cache_build_recipe_path(no_version ${test_prefix} dummy "")

_cpp_add_test(
TITLE "Basic Version Usage"
CONTENTS
    "include(cache/cache_build_recipe)"
    "_cpp_cache_add_build_recipe(${test_prefix} dummy 1.0 \"Hi\")"
    "_cpp_assert_exists(${version})"
    "_cpp_assert_file_contains(\"Hi\" ${version})"
)

_cpp_add_test(
TITLE "Basic non-Version Usage"
CONTENTS
    "include(cache/cache_build_recipe)"
    "_cpp_cache_add_build_recipe(${test_prefix} dummy \"\" \"Hi\")"
    "_cpp_assert_exists(${no_version})"
    "_cpp_assert_file_contains(\"Hi\" ${no_version})"
)

_cpp_add_test(
TITLE "Okay to call twice with same content"
CONTENTS
    "include(cache/cache_build_recipe)"
    "_cpp_assert_exists(${version})"
    "_cpp_cache_add_build_recipe(${test_prefix} dummy 1.0 \"Hi\")"
    "_cpp_assert_exists(${version})"
    "_cpp_assert_file_contains(\"Hi\" ${version})"
)

_cpp_add_test(
TITLE "Fails if called twice with different content"
SHOULD_FAIL REASON "already exists and is different than new build recipe."
CONTENTS
    "include(cache/cache_build_recipe)"
    "_cpp_assert_exists(${version})"
    "_cpp_cache_add_build_recipe(${test_prefix} dummy 1.0 \"Bye\")"
    "_cpp_assert_exists(${version})"
    "_cpp_assert_file_contains(\"Hi\" ${version})"
)
