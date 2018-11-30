include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_build_env("update_find_header")

set(header "some stuff")
set(src_path ${test_prefix}/${test_number})
_cpp_cache_find_module_path(module ${src_path} dummy)
file(WRITE ${module} "Hi")

set(corr "list(APPEND CMAKE_MODULE_PATH ${src_path}/find_recipes/modules)")
_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "message(\"\${CMAKE_MODULE_PATH}\")"
    "include(recipes/cpp_find_recipe_dispatch)"
    "set(header \"${header}\")"
    "_cpp_update_find_header(header ${src_path} dummy ${module})"
    "_cpp_assert_contains(\"${header}\" \"\${header}\")"
    "_cpp_assert_contains(\"${corr}\" \"\${header}\")"
)
