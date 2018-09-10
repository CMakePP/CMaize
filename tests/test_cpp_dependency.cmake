include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_dependency)
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)

#All tests associated with testing the functions in cpp_dependy will go here:
set(test_prefix ${CMAKE_CURRENT_SOURCE_DIR}/cpp_dependency)


################################################################################
#                Test1: Use a recipe to build a trivial dependency             #
################################################################################
_cpp_make_random_dir(test1_prefix ${test_prefix})

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

_cpp_run_sub_build(
    ${test1_prefix}
    CMAKE_ARGS CPP_LOCAL_CACHE=${test1_prefix}/cpp_cache
    INSTALL_PREFIX ${test1_prefix}/install
    NO_INSTALL
)

################################################################################
#          TEST2: Use a recipe to build a GitHub repo                          #
################################################################################
#Note we pick the URL for this repo to test our installation procedure

_cpp_make_random_dir(test2_prefix ${test_prefix})

#Make the build recipe
file(MAKE_DIRECTORY ${test2_prefix}/cmake/build_external)
set(build_recipe ${test2_prefix}/cmake/build_external/BuildCPP.cmake)
file(WRITE ${build_recipe}
     "include(cpp_build_recipes)
cpp_github_cmake(
    CPP
    https://github.com/ryanmrichard/CMakePackagingProject
    TOKEN 1d2e949031a2d3a61b0f288051eed64980c5590c
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
        CMAKE_ARGS CPP_LOCAL_CACHE=${test2_prefix}/cpp_cache
        INSTALL_PREFIX ${test2_prefix}/install
        NO_INSTALL
)
