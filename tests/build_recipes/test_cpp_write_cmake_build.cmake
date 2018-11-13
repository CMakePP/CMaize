include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("write_cmake_build")

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "_cpp_write_cmake_build("
    "   ${src_dir}/build-dummy.cmake"
    "   ${src_dir}/dummy"
    "   ${src_dir}/install"
    "   ${CMAKE_TOOLCHAIN_FILE}"
    ")"
    "_cpp_assert_exists(${src_dir}/build-dummy.cmake)"
)

_cpp_add_test(
TITLE "Recipe works"
CONTENTS
    "include(${src_dir}/build-dummy.cmake)"
    "_cpp_assert_exists(${src_dir}/install)"
)
