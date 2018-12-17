include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("tar_directory")

_cpp_dummy_cxx_library(${test_prefix}/dummy)


_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "_cpp_tar_directory("
    "   ${test_prefix}/${test_number}/test.tar.gz"
    "   ${test_prefix}/dummy"
    ")"
    "_cpp_assert_exists(${test_prefix}/${test_number}/test.tar.gz)"
)

_cpp_add_test(
TITLE "Crashes if not a directory"
SHOULD_FAIL REASON "The path not/a/real/path is not a directory."
CONTENTS
    "_cpp_tar_directory(${test_prefix}/test.tar.gz not/a/real/path)"
)
