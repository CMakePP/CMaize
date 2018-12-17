include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("cache_find_recipe_path")

_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "include(cache/cache_paths)"
    "_cpp_cache_find_recipe_path(output ${test_prefix} dummy)"
    "_cpp_assert_equal("
    "   \"\${output}\""
    "   \"${test_prefix}/find_recipes/find-dummy.cmake\""
    ")"
)
