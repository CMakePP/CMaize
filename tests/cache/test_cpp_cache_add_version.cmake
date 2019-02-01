include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("cache_add_version")

set(cache ${test_prefix}/${test_number}/cache)
_cpp_add_test(
TITLE "Fails if version is empty."
SHOULD_FAIL REASON "Version can not be empty."
"include(cache/add_version)"
"include(cache/ctor)"
"_cpp_Cache_ctor(handle ${cache})"
"_cpp_cache_add_version(\${handle} test dummy \"\")"
)

set(cache ${test_prefix}/${test_number}/cache)
_cpp_add_test(
TITLE "Basic usage."
"include(cache/add_version)"
"include(cache/ctor)"
"_cpp_Cache_ctor(handle ${cache})"
"_cpp_assert_does_not_exist(${cache}/dummy/1.0)"
"_cpp_cache_add_version(\${handle} test dummy 1.0)"
"_cpp_assert_exists(${cache}/dummy/1.0)"
)
