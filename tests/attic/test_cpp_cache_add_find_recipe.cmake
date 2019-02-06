include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_test_env("cache_add_find_recipe")

_cpp_cache_find_recipe_path(path ${test_prefix} dummy)

_cpp_add_test(
TITLE "Basic Usage"
CONTENTS
    "include(cache/cache_find_recipe)"
    "_cpp_cache_add_find_recipe(${test_prefix} dummy \"Hi\")"
    "_cpp_assert_exists(${path})"
    "_cpp_assert_file_contains(\"Hi\" ${path})"
)

_cpp_add_test(
TITLE "Okay to call twice with same content"
CONTENTS
    "include(cache/cache_find_recipe)"
    "_cpp_assert_exists(${path})"
    "_cpp_cache_add_find_recipe(${test_prefix} dummy \"Hi\")"
    "_cpp_assert_exists(${path})"
    "_cpp_assert_file_contains(\"Hi\" ${path})"
)

_cpp_add_test(
TITLE "Fails if called twice with different content"
SHOULD_FAIL REASON "already exists and is different than new find recipe."
CONTENTS
    "include(cache/cache_find_recipe)"
    "_cpp_assert_exists(${path})"
    "_cpp_cache_add_find_recipe(${test_prefix} dummy \"Bye\")"
)
