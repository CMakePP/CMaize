include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)
include(cpp_dependency)
include(cpp_assert)
set(CPP_DEBUG_MODE ON)
_cpp_setup_build_env("cpp_dependency")

function(_cpp_make_build_recipe _cmbr_prefix _cmbr_name)
    file(
            WRITE ${_cmbr_prefix}/build-${_cmbr_name}.cmake
            "include(cpp_build_recipes)
         cpp_local_cmake(${_cmbr_name} ${_cmbr_prefix}/${_cmbr_name})"
    )
endfunction()

#Control toolchain


#Control name

#set(PROJECT_NAME "cpp_dependency")
#
##All defaults
#_cpp_depend_install_path(test1_return dummy)
#_cpp_assert_equal(
#    "${test_prefix}/cpp_cache/dummy/cpp_dependency/${toolchain_hash}"
#    "${test1_return}"
#)
#
##Different project name
#_cpp_depend_install_path(test2_return dummy PROJECT_NAME dummy)
#_cpp_assert_equal(
#    "${test_prefix}/cpp_cache/dummy/dummy/${toolchain_hash}"
#    "${test2_return}"
#)
#
##Different cache
#_cpp_depend_install_path(test3_return dummy CPP_CACHE ${test_prefix}/dummy)
#_cpp_assert_equal(
#    "${test_prefix}/dummy/dummy/cpp_dependency/${toolchain_hash}"
#    "${test3_return}"
#)
#
##Different Toolchain
#file(WRITE ${test_prefix}/dummy_toolchain.cmake "")
#file(SHA1 ${test_prefix}/dummy_toolchain.cmake dummy_hash)
#_cpp_depend_install_path(
#    test4_return
#    dummy
#    TOOLCHAIN_FILE ${test_prefix}/dummy_toolchain.cmake
#)
#_cpp_assert_equal(
#    "${test_prefix}/cpp_cache/dummy/cpp_dependency/${dummy_hash}"
#    "${test4_return}"
#)
#
#################################################################################
## Test _cpp_build_dependency
#################################################################################
#
##This test also makes sure we can find the cached version after we built it.
#set(test_root ${test_prefix}/build_depend)
#set(test1_root ${test_root}/test1)
#_cpp_dummy_cxx_package(${test1_root})
#_cpp_make_build_recipe(${test1_root} dummy)
#
#_cpp_run_sub_build(
#        ${test1_root}
#        NO_INSTALL
#        OUTPUT test1_output
#        NAME build_depend_test
#        CONTENTS "_cpp_build_dependency(dummy ${test1_root}/build-dummy.cmake)
#                  _cpp_find_dependency(test1_found dummy)"
#)
#set(
#    cache_root
#    ${test_prefix}/cpp_cache/dummy/build_depend_test/${toolchain_hash}
#)
#set(share_root ${cache_root}/share/cmake/dummy)
#_cpp_assert_contains(
#    "Found config file: ${share_root}/dummy-config.cmake"
#    "${test1_output}"
#)
#_cpp_assert_exists(${cache_root}/include/dummy/a.hpp)
#foreach(cmake_file dummy-config dummy-config-version dummy-targets)
#        _cpp_assert_exists(${share_root}/${cmake_file}.cmake)
#endforeach()
#
#################################################################################
## _cpp_find_dependency and cpp_find_dependency
#################################################################################
#
#set(test_root ${test_prefix}/find_depend)
#set(test1_root ${test_root}/test1)
#_cpp_install_dummy_cxx_package(${test1_root})
#
##Test we can find the user-specified version
#_cpp_run_sub_build(
#        ${test1_root}
#        NO_INSTALL
#        OUTPUT test1_output
#        NAME find_dummy
#        CONTENTS "set(dummy_ROOT ${test1_root}/install)
#                  _cpp_find_dependency(test1_found dummy)
#                  cpp_find_dependency(dummy)"
#)
#set(test1_path ${test1_root}/install/share/cmake/dummy/dummy-config.cmake)
#_cpp_assert_contains("Found config file: ${test1_path}" "${test1_output}")
#
##Test library DNE
#set(test2_root ${test_root}/test2)
#_cpp_test_build_fails(
#    PATH ${test2_root}
#    NAME find_dne_depend
#    CONTENTS "cpp_find_dependency(dummy2)"
#    REASON "Unable to locate suitable version of dependency: dummy2"
#
#)
#
#################################################################################
## Test _cpp_write_recipe
#################################################################################
#set(test_root ${test_prefix}/write_recipe)
#set(test1_path ${test_root}/test1)
#set(test1_recipe ${test1_path}/build-dummy.cmake)
#_cpp_dummy_cxx_package(${test1_path})
#_cpp_write_recipe(${test1_recipe} dummy PATH a/path)
#_cpp_assert_exists(${test1_recipe})
#_cpp_assert_file_contains("include(cpp_build_recipes)" "${test1_recipe}")
#_cpp_assert_file_contains("cpp_local_cmake(dummy a/path)" "${test1_recipe}")
#
#set(test2_path ${test_root}/test2)
#set(test2_recipe ${test2_path}/build-dummy.cmake)
#_cpp_write_recipe(${test2_recipe} dummy URL https://github.com/a_repo)
#_cpp_assert_exists(${test2_recipe})
#_cpp_assert_file_contains("include(cpp_build_recipes)" "${test2_recipe}")
#_cpp_assert_file_contains("cpp_github_cmake(" "${test2_recipe}")
#_cpp_assert_file_contains("https://github.com/a_repo" "${test2_recipe}")
#
#################################################################################
## Test cpp_find_or_build_dependency
#################################################################################
#set(test_root ${test_prefix}/find_build_depend)
#set(test1_root ${test_root}/test1)
#_cpp_dummy_cxx_package(${test1_root} NAME dummy2)
#_cpp_run_sub_build(
#    ${test1_root}
#    NO_INSTALL
#    OUTPUT test1_output
#    NAME find_or_build_dummy
#    CONTENTS "cpp_find_or_build_dependency(
#                  dummy2
#                  PATH ${test1_root}/dummy2
#              )"
#)
#set(
#    test_dir
#    ${test_prefix}/cpp_cache/dummy2/find_or_build_dummy/${toolchain_hash}
#)
#_cpp_assert_exists(${test_dir}/share/cmake/dummy2/dummy2-config.cmake)
#
#set(test2_root ${test_root}/test2)
#_cpp_run_sub_build(
#        ${test2_root}
#        NO_INSTALL
#        OUTPUT test2_output
#        NAME find_or_build_dummy
#        CONTENTS "cpp_find_or_build_dependency(
#                      cpp
#                      URL github.com/CMakePackagingProject/CMakePackagingProject
#                  )"
#)
#set(
#    test_dir
#    ${test_prefix}/cpp_cache/cpp/find_or_build_dummy/${toolchain_hash}
#)
#_cpp_assert_exists(${test_dir}/share/cmake/cpp/cpp-config.cmake)
#
#set(test3_root ${test_root}/test3)
#_cpp_dummy_cxx_package(${test3_root})
#_cpp_write_recipe(
#    ${test3_root}/build-dummy.cmake dummy
#    PATH ${test3_root}/dummy
#)
#_cpp_run_sub_build(
#        ${test3_root}
#        NO_INSTALL
#        OUTPUT test3_output
#        NAME find_or_build_dummy
#        CONTENTS "set(CPP_DEBUG_MODE ON)
#                  cpp_find_or_build_dependency(
#                      dummy
#                      RECIPE ${test3_root}/build-dummy.cmake
#                  )"
#)
#set(
#    test_dir
#    ${test_prefix}/cpp_cache/dummy/find_or_build_dummy/${toolchain_hash}
#)
#_cpp_assert_exists(${test_dir}/share/cmake/dummy/dummy-config.cmake)
