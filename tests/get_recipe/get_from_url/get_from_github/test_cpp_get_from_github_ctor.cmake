include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_from_github_ctor")

_cpp_add_test(
TITLE "Fails if URL is not for GitHub"
SHOULD_FAIL REASON "URL: hi.com does not appear to be a GitHub URL."
"include(get_recipe/get_from_url/get_from_github/ctor)"
"_cpp_GetFromGitHub_ctor(handle \"hi.com\" \"\" depend \"\" FALSE)"
)

_cpp_add_test(
TITLE "Branch defaults to master."
"include(get_recipe/get_from_url/get_from_github/ctor)"
"_cpp_GetFromGitHub_ctor(handle \"github.com/org/repo\" \"\" depend \"\" FALSE)"
"_cpp_Object_get_value(\${handle} test url)"
"_cpp_assert_equal("
"   \"\${test}\""
"   \"https://api.github.com/repos/org/repo/tarball/master\""
")"
)

_cpp_add_test(
TITLE "Can change branch."
"include(get_recipe/get_from_url/get_from_github/ctor)"
"_cpp_GetFromGitHub_ctor(handle \"github.com/org/repo\" \"branch\" depend \"\"
FALSE)"
"_cpp_Object_get_value(\${handle} test url)"
"_cpp_assert_equal("
"   \"\${test}\""
"   \"https://api.github.com/repos/org/repo/tarball/branch\""
")"
)
