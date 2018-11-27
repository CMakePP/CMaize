include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("get_recipe_path")

_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "include(cache/cache_get_recipe)"
    "_cpp_cache_get_recipe_path(output ${test_prefix} dummy)"
    "_cpp_assert_equal("
    "   \"\${output}\""
    "   \"${test_prefix}/get_recipes/get-dummy.cmake\""
    ")"
)
