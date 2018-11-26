include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("get_gh_url")

#All of the returns start the same prefix
set(prefix "https://api.github.com/repos/organization/repo/tarball")

_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "_cpp_get_gh_url(output URL github.com/organization/repo)"
    "_cpp_assert_equal(\"${prefix}/master\" \"\${output}\")"
)

_cpp_add_test(
TITLE "Works if https:// is in URL"
CONTENTS
    "_cpp_get_gh_url(output URL https://github.com/organization/repo)"
    "_cpp_assert_equal(\"${prefix}/master\" \"\${output}\")"
)

_cpp_add_test(
TITLE "Works if www. is in URL"
CONTENTS
    "_cpp_get_gh_url(output URL www.github.com/organization/repo)"
    "_cpp_assert_equal(\"${prefix}/master\" \"\${output}\")"
)

_cpp_add_test(
TITLE "Honors BRANCH keyword"
CONTENTS
    "_cpp_get_gh_url(output URL github.com/organization/repo BRANCH toy)"
    "_cpp_assert_equal(\"${prefix}/toy\" \"\${output}\")"
)

_cpp_add_test(
TITLE "Honors PRIVATE keyword"
CONTENTS
    "set(CPP_GITHUB_TOKEN 312)"
    "_cpp_get_gh_url(output URL github.com/organization/repo PRIVATE)"
    "_cpp_assert_equal(\"${prefix}/master?access_token=312\" \"\${output}\")"
)

_cpp_add_test(
TITLE "Fails if URL is not set"
SHOULD_FAIL REASON "Required option _cggu_URL is not set"
CONTENTS "_cpp_get_gh_url(output)"
)

_cpp_add_test(
TITLE "Fails if PRIVATE keyword is present, but CPP_GITHUB_TOKEN is not set"
SHOULD_FAIL REASON  "For private repos CPP_GITHUB_TOKEN must be a valid token."
CONTENTS
    "set(CPP_GITHUB_TOKEN \"\")"
    "_cpp_get_gh_url(output URL github.com/organization/repo PRIVATE)"
)

_cpp_add_test(
TITLE "Crashes if github.com is not in URL"
SHOULD_FAIL
REASON  "Substring \"github.com\" not contained in string \"organization/repo\""
CONTENTS "_cpp_get_gh_url(output URL organization/repo)"
)
