include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_build_env("cache_build_recipe")

_cpp_cache_build_recipe_path(version ${test_prefix} dummy 1.0)
_cpp_cache_build_recipe_path(no_version ${test_prefix} dummy "")

file(WRITE ${version} "Hi")
file(WRITE ${no_version} "Hi")


_cpp_add_test(
TITLE "Basic Version Usage"
CONTENTS
    "include(cache/cache_build_recipe)"
    "_cpp_cache_build_recipe(output ${test_prefix} dummy 1.0)"
    "_cpp_assert_equal(\${output} ${version})"
)

_cpp_add_test(
TITLE "Basic Non-Version Usage"
CONTENTS
    "include(cache/cache_build_recipe)"
    "_cpp_cache_build_recipe(output ${test_prefix} dummy \"\")"
    "_cpp_assert_equal(\${output} ${no_version})"
)

_cpp_add_test(
TITLE "Fails if version dne"
SHOULD_FAIL REASON "does not exist."
CONTENTS
    "include(cache/cache_build_recipe)"
    "_cpp_cache_build_recipe(output ${test_prefix} dummy 1.1)"
)
