include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_from_url_ctor")

_cpp_add_test(
TITLE "Not setting a URL is an error."
SHOULD_FAIL REASON "No URL was specified."
"include(get_recipe/get_from_url/ctor)"
"_cpp_GetFromURL_ctor(handle \"\" depend \"\")"
)

_cpp_add_test(
TITLE "Sets URL"
"include(get_recipe/get_from_url/ctor)"
"_cpp_GetFromURL_ctor(handle \"www.hi.com\" depend \"\")"
"_cpp_Object_get_value(\${handle} test url)"
"_cpp_assert_equal(\"\${test}\" \"www.hi.com\")"
)
