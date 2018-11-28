include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_build_env("cache_add_find_module")

set(input_module ${test_prefix}/input.cmake)
file(WRITE ${input_module} "Hi")

set(src_path ${test_prefix}/${test_number})
_cpp_cache_find_module_path(path ${src_path} dummy)
_cpp_add_test(
TITLE "Basic Usage"
CONTENTS
    "include(cache/cache_find_module)"
    "_cpp_cache_add_find_module(${src_path} dummy ${input_module})"
    "_cpp_assert_exists(${path})"
    "_cpp_assert_file_contains(\"Hi\" ${path})"
)

_cpp_add_test(
TITLE "Okay to call twice with same content"
CONTENTS
    "include(cache/cache_find_module)"
    "_cpp_assert_exists(${path})"
    "_cpp_cache_add_find_module(${src_path} dummy ${input_module})"
    "_cpp_assert_exists(${path})"
    "_cpp_assert_file_contains(\"Hi\" ${path})"
)

file(WRITE ${input_module} "Bye")
_cpp_add_test(
TITLE "Fails if called twice with different content"
SHOULD_FAIL REASON "already exists and is different than new find module."
CONTENTS
    "include(cache/cache_find_module)"
    "_cpp_assert_exists(${path})"
    "_cpp_cache_add_find_module(${src_path} dummy ${input_module})"
)
