include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("build_recipe_dispatch")

set(src_dir ${test_prefix}/${test_number})
set(install_dir ${src_dir}/install)
_cpp_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Basic CMake project"
"include(recipes/cpp_build_recipe_dispatch)"
"_cpp_assert_does_not_exist(${install_dir}/include)"
"_cpp_build_recipe_dispatch("
"   ${install_dir}"
"   ${src_dir}/dummy"
"   ${CMAKE_TOOLCHAIN_FILE}"
"   \"\""
"   \"\""
")"
"_cpp_assert_exists(${install_dir}/include)"
)

set(src_dir ${test_prefix}/${test_number})
set(install_dir ${src_dir}/install)
_cpp_dummy_cxx_library(${src_dir}/dummy)
file(WRITE ${src_dir}/Builddummy.cmake
"cpp_add_library(
  dummy
  SOURCES  a.cpp
  INCLUDES a.hpp
)
cpp_install(TARGETS dummy)"
)

_cpp_add_test(
TITLE "Build module"
"include(recipes/cpp_build_recipe_dispatch)"
"_cpp_assert_does_not_exist(${install_dir}/include)"
"_cpp_build_recipe_dispatch("
"   ${install_dir}"
"   ${src_dir}/dummy"
"   ${CMAKE_TOOLCHAIN_FILE}"
"   \"\""
"   ${src_dir}/Builddummy.cmake"
")"
"_cpp_assert_exists(${install_dir}/include)"
)
