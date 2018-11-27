include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("get_recipe_dispatch")


set(src_path ${test_prefix}/dummy)
_cpp_dummy_cxx_library(${src_path})

set(path ${test_prefix}/${test_number})
set(recipe ${path}/get-dummy.cmake)
_cpp_add_test(
TITLE "Basic URL"
CONTENTS
    "_cpp_get_recipe_dispatch(${recipe} URL github.com/org/dummy)"
    "_cpp_assert_exists(${recipe})"
)

set(path ${test_prefix}/${test_number})
set(recipe ${path}/get-dummy.cmake)
_cpp_add_test(
TITLE "Basic SOURCE_DIR"
CONTENTS
    "_cpp_get_recipe_dispatch(${recipe} SOURCE_DIR ${src_path})"
    "_cpp_assert_exists(${recipe})"
)

_cpp_add_test(
TITLE "Multiple calls are okay if same recipe"
CONTENTS
    "_cpp_get_recipe_dispatch(${recipe} SOURCE_DIR ${src_path})"
    "_cpp_assert_exists(${recipe})"
)

_cpp_add_test(
TITLE "Multiple calls fail if different recipes"
SHOULD_FAIL REASON "Get recipe already exists with different content."
CONTENTS
    "_cpp_get_recipe_dispatch(${recipe} URL github.com/org/repo)"
)

_cpp_add_test(
TITLE "Fails if URL or SOURCE_DIR is not specified"
SHOULD_FAIL REASON "Not sure how to get source for dependency"
CONTENTS "_cpp_get_recipe_dispatch(${recipe})"
)
