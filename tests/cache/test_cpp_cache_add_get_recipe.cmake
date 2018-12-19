include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("cache_add_get_recipe")

set(corr_path ${test_prefix}/get_recipes/get-dummy.cmake)

_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "include(cache/cache_get_recipe)"
    "_cpp_assert_does_not_exist(${corr_path})"
    "_cpp_cache_add_get_recipe(${test_prefix} dummy hi)"
    "_cpp_assert_exists(${corr_path})"
)

_cpp_add_test(
TITLE "Can add same file multiple times"
CONTENTS
    "include(cache/cache_get_recipe)"
    "_cpp_assert_exists(${corr_path})"
    "_cpp_cache_add_get_recipe(${test_prefix} dummy hi)"
)

_cpp_add_test(
TITLE "Trying to add a different recipe is an error"
SHOULD_FAIL RESON "already exists and is different than new get recipe."
CONTENTS
    "include(cache/cache_get_recipe)"
    "_cpp_cache_add_get_recipe(${test_prefix} dummy bye)"
)
