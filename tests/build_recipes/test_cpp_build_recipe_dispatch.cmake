include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("build_recipe_dispatch")

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Basic CMake usage"
CONTENTS
    "_cpp_build_recipe_dispatch("
    "   ${src_dir}/build-dummy.cmake"
    "   ${src_dir}/dummy"
    "   ${CMAKE_TOOLCHAIN_FILE}"
    "   ${src_dir}/install"
    "   \"\""
    ")"
    "_cpp_assert_exists(${src_dir}/build-dummy.cmake)"
)
