include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("build_recipe_dispatch")

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

set(prefix_dir ${test_prefix}/${test_number})
set(install_dir ${prefix_dir}/install)
_cpp_dummy_cxx_package(${prefix_dir}/src)
file(WRITE ${prefix_dir}/Builddummy.cmake
"include(ExternalProject)
ExternalProject_Add(
   dummy_External
   SOURCE_DIR \${CMAKE_CURRENT_SOURCE_DIR}/dummy
   CMAKE_CACHE_ARGS -DCMAKE_MODULE_PATH:LIST=\${CMAKE_MODULE_PATH}
                    -DCMAKE_INSTALL_PREFIX:PATH=\${CMAKE_INSTALL_PREFIX}
   INSTALL_DIR \${CMAKE_INSTALL_PREFIX}
)"
)

_cpp_add_test(
TITLE "Build module"
"include(recipes/cpp_build_recipe_dispatch)"
"_cpp_assert_does_not_exist(${install_dir}/include)"
"_cpp_build_recipe_dispatch("
"   ${install_dir}"
"   ${prefix_dir}/src"
"   ${CMAKE_TOOLCHAIN_FILE}"
"   \"\""
"   ${prefix_dir}/Builddummy.cmake"
")"
"_cpp_assert_exists(${install_dir}/include)"
)
