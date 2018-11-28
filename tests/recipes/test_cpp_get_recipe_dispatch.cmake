include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("get_recipe_dispatch")

set(header "function(_cpp_get_recipe _cgr_tar _cgr_version)")
set(footer "endfunction()")


_cpp_add_test(
TITLE "Basic URL"
CONTENTS
    "include(recipes/cpp_get_recipe_dispatch)"
    "_cpp_get_recipe_dispatch(output URL github.com/org/dummy)"
    "_cpp_assert_contains(\"_get_from_gh\" \"\${output}\")"
)

set(path ${test_prefix}/${test_number})
set(src_body "_cpp_tar_directory(\\\${_cgr_tar} ${path})")
set(corr "${header}${src_body}${footer}")
_cpp_add_test(
TITLE "Basic SOURCE_DIR"
CONTENTS
    "include(recipes/cpp_get_recipe_dispatch)"
    "_cpp_get_recipe_dispatch(output SOURCE_DIR ${path})"
    "_cpp_assert_equal(\"\${output}\" \"${corr}\")"
)

_cpp_add_test(
TITLE "Fails if URL or SOURCE_DIR is not specified"
SHOULD_FAIL REASON "Not sure how to get source for dependency"
CONTENTS
    "include(recipes/cpp_get_recipe_dispatch)"
    "_cpp_get_recipe_dispatch(output)"
)
