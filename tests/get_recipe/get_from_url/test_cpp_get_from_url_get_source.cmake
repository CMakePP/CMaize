include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_from_url_get_source")

set(url github.com/CMakePackagingProject/CMakePackagingProject)

set(tar_file ${test_prefix}/${test_number}/test.tar)
_cpp_add_test(
TITLE "Basic usage"
"include(get_recipe/get_from_url/get_from_url)"
"_cpp_GetFromURL_ctor(handle ${url} \"\")"
"_cpp_exists(test ${tar_file})"
"_cpp_assert_false(test)"
"_cpp_GetFromURL_get_source(\${handle} ${tar_file})"
"_cpp_exists(test ${tar_file})"
"_cpp_assert_true(test)"
)
