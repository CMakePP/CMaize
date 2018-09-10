include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)

################################################################################
#           Test1: Ensure we can make and install a library                    #
################################################################################
string(RANDOM random_prefix)
set(test1_prefix ${CMAKE_CURRENT_SOURCE_DIR}/${random_prefix})
file(MAKE_DIRECTORY ${test1_prefix})
set(a_src ${test1_prefix}/a.cpp)
set(a_inc ${test1_prefix}/a.hpp)
set(a_list ${test1_prefix}/CMakeLists.txt)
file(WRITE ${a_inc} "int a_fxn();\n")
file(WRITE ${a_src} "int a_fxn(){return 0;}\n")
_cpp_write_top_list(${a_list} TEST1
"include(cpp_targets)
cpp_add_library(TEST1 SOURCES ${a_src} INCLUDES ${a_inc})
"
)
_cpp_run_sub_build(${test1_prefix} INSTALL ${test1_prefix}/install)

################################################################################
#            Test2: Ensure we can link to library from Test1                   #
################################################################################
string(RANDOM random_prefix)
set(test2_prefix ${CMAKE_CURRENT_SOURCE_DIR}/${random_prefix})
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
