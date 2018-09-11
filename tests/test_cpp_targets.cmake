include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)

_cpp_setup_build_env("cpp_targets")

################################################################################
#           Test1: Ensure we can make and install a library                    #
################################################################################
set(test1_prefix ${test_prefix}/test1)
_cpp_dummy_cmake_library(${test1_prefix})
_cpp_run_sub_build(${test1_prefix} INSTALL ${test1_prefix}/install)

################################################################################
#            Test2: Ensure we can link to library from Test1                   #
################################################################################
set(test2_prefix ${test_prefix}/test2)
file(MAKE_DIRECTORY ${test2_prefix})
set(b_src ${test2_prefix}/b.cpp)
set(b_list ${test2_prefix}/CMakeLists.txt)

file(WRITE ${b_src} "#include <test1/a.hpp>\nint b_fxn(){return a_fxn();}\n")
_cpp_write_top_list(${b_list} TEST2
"include(cpp_targets)
find_package(
    test1
    CONFIG
    REQUIRED
    NO_DEFAULT_PATH
    PATHS ${test1_prefix}/install
)
cpp_add_library(TEST2 SOURCES ${b_src} DEPENDS test1::TEST1)
"
)
_cpp_run_sub_build(${test2_prefix} INSTALL ${test2_prefix}/install)
