include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_from_disk_ctor")

_cpp_add_test(
TITLE "Not setting a path is an error."
SHOULD_FAIL REASON "Path can not be empty."
"include(get_recipe/get_from_disk/ctor)"
"_cpp_GetFromDisk_ctor(handle \"\" depend \"\")"
)

_cpp_add_test(
TITLE "Sets path"
"include(get_recipe/get_from_disk/ctor)"
"_cpp_GetFromDisk_ctor(handle \"a/path\" depend \"\")"
"_cpp_Object_get_value(\${handle} test dir)"
"_cpp_assert_equal(\"\${test}\" \"a/path\")"
)
