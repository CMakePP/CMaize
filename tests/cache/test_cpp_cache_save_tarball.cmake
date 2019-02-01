include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("cache_save_tarball")

_cpp_dummy_cxx_package(pkg_dir ${test_prefix}/${test_number})
set(cache ${test_prefix}/cpp_cache)
set(tar_name ${cache}/dummy/latest/tarballs/dummy.latest.tar.gz)
_cpp_add_test(
TITLE "No tarballs in the cache"
"include(cache/ctor)"
"include(cache/save_tarball)"
"include(get_recipe/get_recipe)"
"_cpp_GetRecipe_factory(gr NAME dummy SOURCE_DIR ${pkg_dir})"
"_cpp_Cache_ctor(c ${cache})"
"_cpp_assert_does_not_exist(${tar_name})"
"_cpp_Cache_save_tarball(\${c} path \${gr})"
"_cpp_assert_equal(\"\${path}\" \"${tar_name}\")"
"_cpp_assert_exists(\${path})"
)

_cpp_add_test(
TITLE "If same tarball in cache, does not add a new one"
"include(cache/ctor)"
"include(cache/save_tarball)"
"include(get_recipe/get_recipe)"
"_cpp_GetRecipe_factory(gr NAME dummy SOURCE_DIR ${pkg_dir})"
"_cpp_Cache_ctor(c ${cache})"
"_cpp_assert_exists(${tar_name})"
"_cpp_Cache_save_tarball(\${c} path \${gr})"
"_cpp_assert_equal(\"\${path}\" \"${tar_name}\")"
"_cpp_assert_does_not_exist(${tar_name}.1)"
)

file(WRITE ${pkg_dir}/readme.md "This file exists to change the hash.")
_cpp_add_test(
TITLE "If different tarball in cache, adds it with a suffix."
"include(cache/ctor)"
"include(cache/save_tarball)"
"include(get_recipe/get_recipe)"
"_cpp_GetRecipe_factory(gr NAME dummy SOURCE_DIR ${pkg_dir})"
"_cpp_Cache_ctor(c ${cache})"
"_cpp_assert_exists(${tar_name})"
"_cpp_Cache_save_tarball(\${c} path \${gr})"
"_cpp_assert_equal(\"\${path}\" \"${tar_name}.1\")"
"_cpp_assert_exists(\${path})"
)
