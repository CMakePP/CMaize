include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_recipe_dispatch")


set(header "macro(_cpp_find_recipe _cfr_version _cfr_comps _cfr_path)")
set(args
   "\\\"\\\${_cfr_version}\\\" \\\"\\\${_cfr_comps}\\\" \\\"\\\${_cfr_path}\\\""
)
set(footer "endmacro()")


set(src_dir ${test_prefix}/${test_number})
_cpp_install_naive_cxx_package(install_dir ${src_dir})
_cpp_naive_find_module(module ${src_dir})

set(include "include(recipes/cpp_find_from_module)")
set(fxn "_cpp_find_from_module(dummy ${args})")
_cpp_add_test(
TITLE "User provided module: contents"
CONTENTS
    "include(recipes/cpp_find_recipe_dispatch)"
    "_cpp_find_recipe_dispatch("
    "   output ${src_dir} dummy FIND_MODULE ${module}"
    ")"
    "_cpp_assert_contains(\"${header}\" \"\${output}\")"
    "_cpp_assert_contains(\"${include}\" \"\${output}\")"
    "_cpp_assert_contains(\"${fxn}\" \"\${output}\")"
    "_cpp_assert_contains(\"${footer}\" \"\${output}\")"
)

set(recipe ${test_prefix}/${test_number}/find-dummy.cmake)
_cpp_add_test(
TITLE "User provided module: works"
CONTENTS
    "include(recipes/cpp_find_recipe_dispatch)"
    "_cpp_find_recipe_dispatch("
    "   output ${src_dir} dummy FIND_MODULE ${module}"
    ")"
    "file(WRITE ${recipe} \"\${output}\")"
    "include(${recipe})"
    "_cpp_find_recipe(\"\" \"\" ${src_dir}/install)"
    "_cpp_assert_true(DUMMY_FOUND)"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})

set(include "include(recipes/cpp_find_from_config)")
set(fxn "_cpp_find_from_config(dummy ${args})")
_cpp_add_test(
TITLE "Config file"
CONTENTS
    "include(recipes/cpp_find_recipe_dispatch)"
    "_cpp_find_recipe_dispatch(output ${src_dir} dummy)"
    "_cpp_assert_contains(\"${header}\" \"\${output}\")"
    "_cpp_assert_contains(\"${include}\" \"\${output}\")"
    "_cpp_assert_contains(\"${fxn}\" \"\${output}\")"
    "_cpp_assert_contains(\"${footer}\" \"\${output}\")"
)

set(recipe ${test_prefix}/${test_number}/find-dummy.cmake)
_cpp_add_test(
TITLE "Config file: works"
CONTENTS
    "include(recipes/cpp_find_recipe_dispatch)"
    "_cpp_find_recipe_dispatch(output ${src_dir} dummy)"
    "file(WRITE ${recipe} \"\${output}\")"
    "include(${recipe})"
    "_cpp_find_recipe(\"\" \"\" ${src_dir}/install)"
    "_cpp_assert_true(dummy_FOUND)"
)
