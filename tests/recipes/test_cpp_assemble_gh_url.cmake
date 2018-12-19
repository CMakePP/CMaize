include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("assemble_gh_url")

set(prefix https://api.github.com/repos/org/repo/tarball)

_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "include(recipes/cpp_get_from_gh)"
    "_cpp_assemble_gh_url(url org repo FALSE master \"\")"
    "_cpp_assert_equal(${prefix}/master \${url})"
)

_cpp_add_test(
TITLE "Basic private repo usage"
CONTENTS
    "include(recipes/cpp_get_from_gh)"
    "set(CPP_GITHUB_TOKEN 333)"
    "_cpp_assemble_gh_url(url org repo TRUE master \"\")"
    "_cpp_assert_equal(${prefix}/master?access_token=333 \${url})"
)

_cpp_add_test(
TITLE "Fails if CPP_GITHUB_TOKEN is not set and private repo"
SHOULD_FAIL REASON "CPP_GITHUB_TOKEN must be a valid token."
CONTENTS
    "include(recipes/cpp_get_from_gh)"
    "set(CPP_GITHUB_TOKEN \"\")"
    "_cpp_assemble_gh_url(url org repo TRUE master \"\")"
)
