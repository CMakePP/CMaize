include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_dependency)
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)

_cpp_setup_build_env("cpp_dependency")

#For constructing Cache paths we'll need the hash of the toolchain
file(SHA1 ${CMAKE_TOOLCHAIN_FILE} toolchain_hash)

################################################################################
#                Test1: Use a recipe to build a trivial dependency             #
################################################################################
set(test1_prefix ${test_prefix}/test1)

set(a_root ${test1_prefix}/external/a)
_cpp_dummy_cmake_library(${a_root})

#Make the build recipe
file(MAKE_DIRECTORY ${test1_prefix}/cmake/build_external)
set(build_recipe ${test1_prefix}/cmake/build_external/BuildA.cmake)
file(WRITE ${build_recipe}
"include(cpp_build_recipes)
cpp_local_cmake(A ${a_root})
")

#Make the list for the project that will build the external project
_cpp_write_top_list(
    ${test1_prefix}/CMakeLists.txt
    TEST1
"include(cpp_dependency)
_cpp_build_dependency(A)
"
)
set(CPP_DEBUG_MODE ON)
_cpp_run_sub_build(
    ${test1_prefix}
    NO_INSTALL
)

################################################################################
#          TEST2: Use a recipe to build a GitHub repo                          #
################################################################################
#Note we pick the URL for this repo to test our installation procedure

set(test2_prefix ${test_prefix}/test2)

#Make the build recipe
file(MAKE_DIRECTORY ${test2_prefix}/cmake/build_external)
set(build_recipe ${test2_prefix}/cmake/build_external/BuildCPP.cmake)
file(WRITE ${build_recipe}
     "include(cpp_build_recipes)
cpp_github_cmake(
    CPP
    https://github.com/ryanmrichard/CMakePackagingProject
)
")

#Make the list for the project that will build the external project
_cpp_write_top_list(
    ${test2_prefix}/CMakeLists.txt
    TEST2
"include(cpp_dependency)
_cpp_build_dependency(CPP)
"
)

_cpp_run_sub_build(
    ${test2_prefix}
    NO_INSTALL
)

################################################################################
#                     TEST3: Find the library from TEST1                       #
################################################################################

set(test3_prefix ${test_prefix}/test3)
_cpp_write_top_list(
    ${test3_prefix}/CMakeLists.txt
    TEST1 #Dependencies are tied to the project that built them
"include(cpp_dependency)
include(cpp_checks)
cpp_find_dependency(A_was_found A)
_cpp_assert_true(A_was_found)
"
)

_cpp_run_sub_build(
        ${test3_prefix}
        NO_INSTALL
)

################################################################################
#                   TEST4: Find the library from TEST2                         #
################################################################################
set(test4_prefix ${test_prefix}/test4)
_cpp_write_top_list(
        ${test4_prefix}/CMakeLists.txt
        TEST4
        "include(cpp_dependency)
include(cpp_checks)
cpp_find_dependency(CPP_was_found CPP)
_cpp_assert_true(CPP_was_found)
"
)

_cpp_run_sub_build(
        ${test4_prefix}
        NO_INSTALL
)
