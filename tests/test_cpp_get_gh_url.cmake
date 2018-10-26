include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers.cmake)
include(cpp_dependency)
include(cpp_assert)
set(CPP_DEBUG_MODE ON)
_cpp_setup_build_env("get_gh_url")

#All of the returns start the same
set(common_prefix "https://api.github.com/repos/organization/repo/tarball")

################################################################################
# Test basic usage
################################################################################

_cpp_get_gh_url(test1 URL "github.com/organization/repo")
_cpp_assert_equal("${common_prefix}/master" "${test1}")

################################################################################
# Works with "https://"
################################################################################

_cpp_get_gh_url(test2 URL "https://github.com/organization/repo")
_cpp_assert_equal("${common_prefix}/master" "${test2}")

################################################################################
# Works with "www."
################################################################################

_cpp_get_gh_url(test3 URL "www.github.com/organization/repo")
_cpp_assert_equal("${common_prefix}/master" "${test3}")

################################################################################
# Honors BRANCH keyword
################################################################################

_cpp_get_gh_url(test4 URL "github.com/organization/repo" BRANCH "toy")
_cpp_assert_equal("${common_prefix}/toy" "${test4}")

################################################################################
# Honors TOKEN keyword
################################################################################

_cpp_get_gh_url(test5 URL "github.com/organization/repo" TOKEN "312")
_cpp_assert_equal("${common_prefix}/master?access_token=312" "${test5}")

################################################################################
# Fails if URL is not specified
################################################################################

_cpp_test_build_fails(
    NAME test6
    PATH ${test_prefix}/test6
    CONTENTS "include(cpp_dependency)
             _cpp_get_gh_url(test6)"
        REASON "_cggu_URL is set to false value:"
)
