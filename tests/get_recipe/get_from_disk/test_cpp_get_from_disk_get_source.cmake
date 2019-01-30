include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_from_disk_get_source")

set(test_dir ${test_prefix}/test_dir)
file(MAKE_DIRECTORY ${test_dir})
file(WRITE ${test_dir}/test.txt "hello world")

set(tar_file ${test_prefix}/${test_number}/test.tar)
_cpp_add_test(
TITLE "Basic usage"
"include(get_recipe/get_from_disk/get_from_disk)"
"_cpp_GetFromDisk_ctor(handle ${test_dir} \"\")"
"_cpp_exists(test ${tar_file})"
"_cpp_assert_false(test)"
"_cpp_GetFromDisk_get_source(\${handle} ${tar_file})"
"_cpp_exists(test ${tar_file})"
"_cpp_assert_true(test)"
)
