include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("get_recipe")

set(corr_path ${test_prefix}/get_recipes/get-dummy.cmake)

#CMake inserts a linebreak that makes the full message hard to match
_cpp_add_test(
TITLE "Fails if recipe does not exist"
SHOULD_FAIL REASON "Get recipe"
CONTENTS
    "include(cache/cache_get_recipe)"
    "_cpp_cache_get_recipe(output ${test_prefix} dummy)"
)

_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "include(cache/cache_get_recipe)"
    "file(WRITE ${corr_path} hi)"
    "_cpp_cache_get_recipe(output ${test_prefix} dummy)"
    "_cpp_assert_equal(\${output} ${corr_path})"
)
