include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_package")

set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Find from config"
CONTENTS
    "_cpp_find_from_config(dummy \"\" \"\" ${src_dir}/install)"
    "_cpp_assert_true(dummy_FOUND)"
)

_cpp_add_test(
TITLE "Exits if target exists"
CONTENTS
    "add_library(dummy INTERFACE)"
    "_cpp_find_package(output dummy \"\" \"\" \"\")"
    "_cpp_assert_true(output)"
)

_cpp_add_test(
TITLE "Finds config file"
CONTENTS
    "_cpp_find_package(output dummy \"\" \"\" ${src_dir}/install)"
    "_cpp_assert_true(output)"
)

set(src_dir ${test_prefix}/${test_number})
file(
    WRITE "${src_dir}/Finddummy.cmake"
    "set(dummy_INCLUDES a/path)\nset(dummy_FOUND TRUE)")
_cpp_add_test(
TITLE "Finds module file"
CONTENTS
    "_cpp_find_package(output dummy \"\" \"\" ${src_dir})"
    "_cpp_assert_true(output)"
)
