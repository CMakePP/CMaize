include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_from_url_factory")

_cpp_add_test(
TITLE "If URL contains github makes a GetFromGithub instance."
"include(get_recipe/get_from_url/get_from_url_factory)"
"_cpp_GetFromURL_factory(handle \"github.com/org/repo\" \"\" \"\" FALSE)"
"_cpp_Object_get_type(\${handle} test)"
"_cpp_assert_equal(\"\${test}\" \"GetFromGithub\")"
)

_cpp_add_test(
TITLE "Other URLs lead to GetFromURL instance"
"include(get_recipe/get_from_url/ctor)"
"_cpp_GetFromURL_ctor(handle \"www.hi.com\" \"\")"
"_cpp_Object_get_type(\${handle} test)"
"_cpp_assert_equal(\"\${test}\" \"GetFromURL\")"
)
