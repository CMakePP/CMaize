include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("cache_install_dir")

_cpp_dummy_cxx_package(pkg_dir ${test_prefix}/${test_number})
set(cache ${test_prefix}/cpp_cache)
set(src_name ${cache}/dummy/latest/install)

_cpp_add_test(
TITLE "Basic usage"
"include(cache/cache)"
"include(cache/install_dir)"
"include(get_recipe/get_recipe)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_GetRecipe_factory(gr \${kwargs} NAME dummy SOURCE_DIR ${pkg_dir})"
"_cpp_Cache_ctor(c ${cache})"
"_cpp_Cache_save_source(\${c} path \${gr})"
"_cpp_BuildRecipe_factory(br \${kwargs} \${path} NAME dummy)"
"_cpp_assert_does_not_exist(${src_name})"
"_cpp_Cache_install_dir(\${c} path \${gr} \${br})"
"_cpp_assert_contains(\"${src_name}\" \"\${path}\" )"
"_cpp_assert_exists(\${path})"
)
