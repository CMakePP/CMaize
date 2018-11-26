include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_recipe_dispatch")

set(src_dir ${test_prefix}/${test_number})
_cpp_naive_install_cxx_package(${src_dir})
#Write a typical Finddummy.cmake file
file(
    WRITE "${src_dir}/Finddummy.cmake"
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
_cpp_add_test(
TITLE "User provided: Writes file"
CONTENTS
    "include(cpp_find_recipes)"
    "_cpp_find_recipe_dispatch("
    "   ${src_dir}/find-dummy.cmake"
    "   dummy"
    "   0.0.0"
    "   \"\""
    "   ${src_dir}/Finddummy.cmake"
    ")"
    "_cpp_assert_exists(${src_dir}/find-dummy.cmake)"
)

_cpp_add_test(
TITLE "User provided: Works"
CONTENTS
    "include(${src_dir}/find-dummy.cmake)"
    "_cpp_call_recipe(${src_dir}/dummy/install)"
    "_cpp_assert_true(DUMMY_FOUND)"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Config file: Writes file"
CONTENTS
    "include(cpp_find_recipes)"
    "_cpp_find_recipe_dispatch("
    "   ${src_dir}/find-dummy.cmake"
    "   dummy"
    "   0.0.0"
    "   \"\""
    "   \"\""
    ")"
    "_cpp_assert_exists(${src_dir}/find-dummy.cmake)"
)

_cpp_add_test(
TITLE "Config file: Works"
CONTENTS
    "include(${src_dir}/find-dummy.cmake)"
    "_cpp_call_recipe(${src_dir}/install)"
    "_cpp_assert_true(dummy_FOUND)"
)
