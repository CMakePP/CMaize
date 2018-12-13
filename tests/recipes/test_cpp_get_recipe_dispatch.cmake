include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_recipe_dispatch")

set(tarball ${test_prefix}/${test_number}/cpp.tar.gz)
set(cpp_url "github.com/CMakePackagingProject/CMakePackagingProject")

_cpp_add_test(
TITLE "GitHub URL dispatch"
"include(recipes/cpp_get_recipe_dispatch)"
"_cpp_assert_does_not_exist(${tarball})"
"_cpp_get_recipe_dispatch(${tarball} \"\" ${cpp_url} False \"\" \"\")"
"_cpp_assert_exists(${tarball})"
)

set(src_dir ${test_prefix}/${test_number})
set(tarball ${src_dir}/dummy.tar.gz)
_cpp_dummy_cxx_package(${src_dir})
_cpp_add_test(
TITLE "Local source dispatch"
"include(recipes/cpp_get_recipe_dispatch)"
"_cpp_assert_does_not_exist(${tarball})"
"_cpp_get_recipe_dispatch(${tarball} \"\" \"\" False \"\" ${src_dir}/dummy)"
"_cpp_assert_exists(${tarball})"
)

_cpp_add_test(
TITLE "Fails if URL or SOURCE_DIR is not specified"
SHOULD_FAIL REASON "Not sure how to get source for dependency"
"include(recipes/cpp_get_recipe_dispatch)"
"_cpp_get_recipe_dispatch(dummy.tar.gz \"\" \"\" False \"\" \"\")"
)
