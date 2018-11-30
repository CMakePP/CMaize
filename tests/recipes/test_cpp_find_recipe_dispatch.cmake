include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_recipe_dispatch")


set(header "macro(_cpp_find_recipe _cfr_version _cfr_comps _cfr_path)")
set(args
   "\\\"\\\${_cfr_version}\\\" \\\"\\\${_cfr_comps}\\\" \\\"\\\${_cfr_path}\\\""
)
set(footer "endmacro()")


set(src_dir ${test_prefix}/${test_number})
_cpp_naive_install_cxx_package(${src_dir})
#Write a typical Finddummy.cmake file
file(
    WRITE "${test_prefix}/Finddummy.cmake"
"
find_path(DUMMY_INCLUDE_DIR a.hpp)
find_library(DUMMY_LIBRARY dummy)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    DUMMY DEFAULT_MSG
    DUMMY_LIBRARY
    DUMMY_INCLUDE_DIR
)
set(DUMMY_INCLUDE_DIRS \${DUMMY_INCLUDE_DIR})
set(DUMMY_LIBRARIES \${DUMMY_LIBRARY})
"
)

set(include "include(recipes/cpp_find_from_module)")
set(fxn "_cpp_find_from_module(dummy ${args})")
_cpp_add_test(
TITLE "User provided module: contents"
CONTENTS
    "include(recipes/cpp_find_recipe_dispatch)"
    "_cpp_find_recipe_dispatch("
    "   output ${src_dir} dummy FIND_MODULE ${test_prefix}/Finddummy.cmake"
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
    "   output ${src_dir} dummy FIND_MODULE ${test_prefix}/Finddummy.cmake"
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
