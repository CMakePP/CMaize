include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("parse_gh_url")

_cpp_add_test(
TITLE "Basic URL"
"include(get_recipe/get_from_github/parse_gh_url)"
"_cpp_parse_gh_url(org repo github.com/organization/repo)"
"_cpp_assert_equal(\${org} organization)"
"_cpp_assert_equal(\${repo} repo)"
)

_cpp_add_test(
TITLE "Basic URL with https://"
"include(get_recipe/get_from_github/parse_gh_url)"
"_cpp_parse_gh_url(org repo https://github.com/organization/repo)"
"_cpp_assert_equal(\${org} organization)"
"_cpp_assert_equal(\${repo} repo)"
)

_cpp_add_test(
TITLE "Fails if URL does not contain organization/user"
SHOULD_FAIL REASON "github.com//repo does not appear to contain an organization"
"include(get_recipe/get_from_github/parse_gh_url)"
"_cpp_parse_gh_url(org repo github.com//repo)"
)

_cpp_add_test(
TITLE "Fails if URL does not contain repo"
SHOULD_FAIL REASON "github.com/org/ does not appear to contain a repository."
"include(get_recipe/get_from_github/parse_gh_url)"
"_cpp_parse_gh_url(org repo github.com/org/)"
)
