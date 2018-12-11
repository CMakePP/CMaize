include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_build_env("cache_add_dependency")

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(${src_dir})
_cpp_add_test(
TITLE "Write get recipe"
CONTENTS
    "include(cache/cache_add_dependency)"
    "_cpp_cache_write_get_recipe("
    "   ${src_dir}"
    "   dummy"
    "   \"\""
    "   SOURCE_DIR ${src_dir}/dummy"
    ")"
    "_cpp_assert_exists(${src_dir}/get_recipes)"
)
_cpp_add_test(
TITLE "Write build recipe"
CONTENTS
    "include(cache/cache_add_dependency)"
    "_cpp_cache_write_build_recipe("
    "   ${src_dir}"
    "   dummy"
    ")"
    "_cpp_assert_exists(${src_dir}/build_recipes)"
)
_cpp_add_test(
TITLE "Write find recipe"
CONTENTS
    "include(cache/cache_add_dependency)"
    "_cpp_cache_write_find_recipe("
    "   ${src_dir}"
    "   dummy"
    ")"
    "_cpp_assert_exists(${src_dir}/find_recipes)"
)
