include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_recipe_get_source")

set(url github.com/CMakePackagingProject/CMakePackagingProject)

set(tar_file ${test_prefix}/${test_number}/test.tar)
_cpp_add_test(
TITLE "Correctly dispatches to GetFromURL"
"include(get_recipe/get_from_url/get_from_url)"
"include(get_recipe/get_source)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_GetFromURL_ctor(handle ${url} \${kwargs} NAME depend)"
"_cpp_exists(test ${tar_file})"
"_cpp_assert_false(test)"
"_cpp_GetRecipe_get_source(\${handle} ${tar_file})"
"_cpp_exists(test ${tar_file})"
"_cpp_assert_true(test)"
)

set(test_dir ${test_prefix}/test_dir)
file(MAKE_DIRECTORY ${test_dir})
file(WRITE ${test_dir}/test.txt "hello world")

set(tar_file ${test_prefix}/${test_number}/test.tar)
_cpp_add_test(
TITLE "Correctly dispatches to GetFromDisk"
"include(get_recipe/get_from_disk/get_from_disk)"
"include(get_recipe/get_source)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_GetFromDisk_ctor(handle ${test_dir} \${kwargs} NAME depend)"
"_cpp_exists(test ${tar_file})"
"_cpp_assert_false(test)"
"_cpp_GetRecipe_get_source(\${handle} ${tar_file})"
"_cpp_exists(test ${tar_file})"
"_cpp_assert_true(test)"
)
