include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("url_dispatcher")

set(corr_gh_url "https://api.github.com/repos/org/repo/tarball/master")

_cpp_add_test(
TITLE "GitHub URL"
CONTENTS
    "_cpp_url_dispatcher(test a/path \"github.com/org/repo\" \"\")"
    "_cpp_assert_equal("
    "    \"_cpp_download_tarball(a/path ${corr_gh_url})\" \"\${test}\""
    ")"
)

_cpp_add_test(
TITLE "Direct download link"
CONTENTS
    "_cpp_url_dispatcher(test a/path \"www.website.com\" \"\")"
    "_cpp_assert_equal("
    "    \"_cpp_download_tarball(a/path www.website.com)\" \"\${test}\""
    ")"
)

