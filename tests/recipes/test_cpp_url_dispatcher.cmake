include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("url_dispatcher")


set(tarball ${test_prefix}/${test_number}/cpp.tar.gz)
set(cpp_url "github.com/CMakePackagingProject/CMakePackagingProject")
_cpp_add_test(
TITLE "Basic GitHub usage"
CONTENTS
    "include(recipes/cpp_url_dispatcher)"
    "_cpp_assert_does_not_exist(${tarball})"
    "_cpp_url_dispatcher(${tarball} \"\" ${cpp_url} False \"\")"
    "_cpp_assert_exists(${tarball})"
)

