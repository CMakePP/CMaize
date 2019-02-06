include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("cache_add_dependency")

set(cache ${test_prefix}/${test_number}/cache)
_cpp_add_test(
TITLE "Fails if name is empty."
SHOULD_FAIL REASON "Name of dependency can not be empty."
"include(cache/add_dependency)"
"include(cache/ctor)"
"_cpp_Cache_ctor(handle ${cache})"
"_cpp_Cache_add_dependency(\${handle} test \"\")"
)

set(cache ${test_prefix}/${test_number}/cache)
_cpp_add_test(
TITLE "Basic usage."
"include(cache/add_dependency)"
"include(cache/ctor)"
"_cpp_Cache_ctor(handle ${cache})"
"_cpp_assert_does_not_exist(${cache}/dummy)"
"_cpp_Cache_add_dependency(\${handle} test dummy)"
"_cpp_assert_exists(${cache}/dummy)"
"_cpp_assert_equal(\"\${test}\" \"${cache}/dummy\")"
)
