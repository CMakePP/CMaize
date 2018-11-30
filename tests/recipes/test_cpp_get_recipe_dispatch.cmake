include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("get_recipe_dispatch")

_cpp_add_test(
TITLE "Basic URL: contents"
CONTENTS
    "include(recipes/cpp_get_recipe_dispatch)"
    "_cpp_get_recipe_dispatch(output URL github.com/org/dummy)"
    "_cpp_assert_contains(\"_get_from_gh\" \"\${output}\")"
)

set(src_dir ${test_prefix}/${test_number})
set(recipe ${src_dir}/get-dummy.cmake)
_cpp_add_test(
TITLE "Basic URL: works"
CONTENTS
    "include(recipes/cpp_get_recipe_dispatch)"
    "_cpp_get_recipe_dispatch(output URL github.com/org/dummy)"
    "file(WRITE ${recipe} \"\${output}\")"
    "include(${recipe})"
    "_cpp_get_recipe(${src_dir}/test.tar.gz \"\")"
    "_cpp_assert_exists(${src_dir}/test.tar.gz)"
)

set(path ${test_prefix}/${test_number})
set(src_body "_cpp_tar_directory(\\\${_cgr_tar} ${path})")

_cpp_add_test(
TITLE "Basic SOURCE_DIR: contents"
CONTENTS
    "include(recipes/cpp_get_recipe_dispatch)"
    "_cpp_get_recipe_dispatch(output SOURCE_DIR ${path})"
    "_cpp_assert_contains(\"_cpp_tar_directory\" \"\${output}\")"
)

set(src_dir ${test_prefix}/${test_number})
set(recipe ${src_dir}/get-dummy.cmake)
_cpp_add_test(
TITLE "Basic contents: works"
CONTENTS
    "include(recipes/cpp_get_recipe_dispatch)"
    "_cpp_get_recipe_dispatch(output SOURCE_DIR ${path})"
    "file(WRITE ${recipe} \"\${output}\")"
    "include(${recipe})"
    "_cpp_get_recipe(${src_dir}/test.tar.gz \"\")"
    "_cpp_assert_exists(${src_dir}/test.tar.gz)"
)

_cpp_add_test(
TITLE "Fails if URL or SOURCE_DIR is not specified"
SHOULD_FAIL REASON "Not sure how to get source for dependency"
CONTENTS
    "include(recipes/cpp_get_recipe_dispatch)"
    "_cpp_get_recipe_dispatch(output)"
)
