include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_build_env("cache_find_module")

_cpp_cache_find_module_path(path ${test_prefix} dummy)
file(WRITE ${path} "Hi")

_cpp_add_test(
TITLE "Basic Usage"
CONTENTS
    "include(cache/cache_find_module)"
    "_cpp_cache_find_module(output ${test_prefix} dummy)"
    "_cpp_assert_equal(\${output} ${path})"
)

_cpp_add_test(
TITLE "Fails if version dne"
SHOULD_FAIL REASON "does not exist."
CONTENTS
    "include(cache/cache_find_module)"
    "_cpp_cache_find_module(output ${test_prefix}/${test_number} dummy)"
)
