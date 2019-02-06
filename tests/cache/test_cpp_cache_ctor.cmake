include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("cache_ctor")

set(cache ${test_prefix}/${test_number}/cache)
_cpp_add_test(
TITLE "Makes cache if not already directory."
"include(cache/ctor)"
"_cpp_assert_does_not_exist(${cache})"
"_cpp_Cache_ctor(handle ${cache})"
"_cpp_Object_get_value(\${handle} test root)"
"_cpp_assert_equal(\"\${test}\" \"${cache}\")"
"_cpp_assert_exists(${cache})"
)

_cpp_add_test(
TITLE "Basic usage"
"include(cache/ctor)"
"_cpp_assert_exists(${CPP_INSTALL_CACHE})"
"_cpp_Cache_ctor(handle ${CPP_INSTALL_CACHE})"
"_cpp_Object_get_value(\${handle} test root)"
"_cpp_assert_equal(\"\${test}\" \"${CPP_INSTALL_CACHE}\")"
)


