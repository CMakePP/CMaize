include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)

_cpp_setup_build_env("cpp_build_recipes")

################################################################################
# Test adding of local cmake project
################################################################################

#Set-up a little dummy library
set(test_root ${test_prefix}/local_cmake)
set(test1_root ${test_root}/test1)
_cpp_dummy_cxx_package(${test1_root})

set(CPP_DEBUG_MODE ON)
_cpp_run_sub_build(
        ${test1_root}
        INSTALL_PREFIX ${test1_root}/install
        OUTPUT test1_output
        NAME test1
        CONTENTS "include(cpp_build_recipes)
                  cpp_local_cmake(test1 ${test1_root}/external/dummy)"
)
set(TEST1_SHARE ${test1_root}/install/share/cmake/dummy)
_cpp_assert_exists(${TEST1_SHARE}/dummy-config.cmake)
_cpp_assert_exists(${TEST1_SHARE}/dummy-config-version.cmake)
_cpp_assert_exists(${TEST1_SHARE}/dummy-targets.cmake)
_cpp_assert_exists(${test1_root}/install/include/dummy/a.hpp)

################################################################################
# Test _cpp_parse_gh_url
################################################################################

set(repo "CMakePackagingProject/CMakePackagingProject")
set(test_root ${test_prefix}/parse_gh)
_cpp_run_sub_build(
    ${test_root}/test1
    NO_INSTALL
    NAME test1
    CONTENTS "include(cpp_build_recipes)
              include(cpp_assert)
              _cpp_parse_gh_url(test1_return \"https://www.github.com/${repo}\")
              _cpp_assert_equal(\"${repo}\" \"\${test1_return}\")"
)

#URL without https://
_cpp_run_sub_build(
    ${test_root}/test2
    NO_INSTALL
    NAME test2
    CONTENTS "include(cpp_build_recipes)
              include(cpp_assert)
              _cpp_parse_gh_url(test2_return \"www.github.com/${repo}\")
              _cpp_assert_equal(\"${repo}\" \"\${test2_return}\")"
)


#URL without https://www.
_cpp_run_sub_build(
    ${test_root}/test3
    NO_INSTALL
    NAME test3
    CONTENTS "include(cpp_build_recipes)
              include(cpp_assert)
              _cpp_parse_gh_url(test3_return \"github.com/${repo}\")
              _cpp_assert_equal(\"${repo}\" \"\${test3_return}\")"
)

################################################################################
# Test cpp_github_cmake
################################################################################

set(test_root ${test_prefix}/github_cmake)

#We choose this project so this also serves as a test for whether or not this
#project's build is working

_cpp_run_sub_build(
    ${test_root}/test1
    INSTALL_PREFIX ${test_root}/test1/install
    OUTPUT test1_output
    CMAKE_ARGS -DBUILD_TESTS=off
    NAME test1
    CONTENTS "include(cpp_build_recipes)
              cpp_github_cmake(CMakePackagingProject \"github.com/${repo}\")"
)
set(test1_share ${test_root}/test1/install/share/cmake/cpp)
foreach(mod cpp-config cpp-config-version CPPMain cpp_assert cpp_build_recipes
    cpp_checks  cpp_cmake_helpers cpp_dependency cpp_options cpp_print
    cpp_targets cpp_tests cpp_toolchain
)
    _cpp_assert_exists(${test1_share}/${mod}.cmake)
endforeach()
_cpp_assert_exists(${test1_share}/Config.cmake.in)
