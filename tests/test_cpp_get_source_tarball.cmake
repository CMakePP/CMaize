include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers.cmake)
_cpp_setup_build_env("get_source_tarball")

set(common_fail "Please specify either URL or SOURCE_DIR")
set(prefix "_cpp_get_source_tarball(${test_prefix}/")
_cpp_add_test(
TITLE "Fails if URL or SOURCE_DIR is not set"
SHOULD_FAIL REASON "${common_fail}"
CONTENTS "${prefix}/${test_number}.tar.gz)"
)

_cpp_add_test(
TITLE "Fails if both URL and SOURCE_DIR are set"
SHOULD_FAIL REASON "${common_fail}"
CONTENTS "${prefix}/${test_number}.tar.gz URL x/a SOURCE_DIR a/path)"
)

_cpp_add_test(
TITLE "Fails if we can't parse the url"
SHOULD_FAIL REASON "not/a/url does not appear to be a valid URL."
CONTENTS "${prefix}/${test_number}.tar.gz URL not/a/url)"
)

_cpp_dummy_cxx_library(${test_prefix}/dummy)
_cpp_add_test(
TITLE "Can tar a local directory"
CONTENTS
    "${prefix}/${test_number}.tar.gz SOURCE_DIR ${test_prefix}/dummy)"
    "_cpp_assert_exists(${test_prefix}/${test_number}.tar.gz)"
)

set(cpp_url "github.com/CMakePackagingProject/CMakePackagingProject")
_cpp_add_test(
TITLE "Can tar a GitHub repo"
CONTENTS
    "${prefix}/${test_number}.tar.gz URL ${cpp_url})"
    "_cpp_assert_exists(${test_prefix}/${test_number}.tar.gz)"
)
