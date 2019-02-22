include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_from_gitlab_ctor")

_cpp_add_test(
TITLE "Fails if URL is not for GitHub"
SHOULD_FAIL REASON "URL: hi.com does not appear to be a GitLab URL."
"include(get_recipe/get_from_url/get_from_gitlab/ctor)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_GetFromGitLab_ctor(handle \"hi.com\" \${kwargs} NAME depend)"
)
