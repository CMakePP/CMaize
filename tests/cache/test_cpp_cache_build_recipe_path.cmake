include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("build_recipe_path")

_cpp_add_test(
TITLE "Basic Usage"
CONTENTS
    "include(cache/cache_paths)"
    "_cpp_cache_build_recipe_path(output ${test_prefix} dummy)"
    "_cpp_assert_equal("
    "   \"\${output}\""
    "   \"${test_prefix}/build_recipes/build-dummy.cmake\""
    ")"
)
