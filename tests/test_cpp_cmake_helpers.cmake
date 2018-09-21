include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)

_cpp_setup_build_env(cpp_cmake_helpers)


################################################################################
# Test _cpp_write_top_list
################################################################################

#Basic usage
_cpp_write_top_list(
    PATH ${test_prefix}/top_list
    NAME top_list_test
    CONTENTS "Hi"
)
_cpp_assert_exists(${test_prefix}/top_list/CMakeLists.txt)
file(READ ${test_prefix}/top_list/CMakeLists.txt test1_contents)
set(test1_corr
"cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(top_list_test VERSION 0.0.0)
include(CPPMain)
CPPMain()
Hi
"
)
_cpp_assert_equal("${test1_contents}" "${test1_corr}")

#No PATH == no run
_cpp_run_cmake_command(
        COMMAND "_cpp_write_top_list(NAME top_list_test CONTENTS \"Hi\")"
        BINARY_DIR ${test_prefix}/no_path
        INCLUDES cpp_cmake_helpers
        OUTPUT test2_output
        RESULT test2_result
)
#Failed runs return error code 1, which is true-y
_cpp_assert_true(test2_result)
_cpp_assert_contains("_cwtl_path is set to false value: 0" "${test2_output}")

#No NAME == no run
_cpp_run_cmake_command(
        COMMAND
            "_cpp_write_top_list(PATH ${test_prefix}/top_list CONTENTS \"Hi\")"
        BINARY_DIR ${test_prefix}/no_name
        INCLUDES cpp_cmake_helpers
        OUTPUT test3_output
        RESULT test3_result
)
_cpp_assert_true(test3_result)
_cpp_assert_contains("_cwtl_name is set to false value: 0" "${test3_output}")

################################################################################
# Test _cpp_run_cmake_command
################################################################################

#Default-ish usage
set(CMAKE_BINARY_DIR ${test_prefix}/test4)
_cpp_run_cmake_command(
    COMMAND "message(\"Hi\")"
    RESULT test4_result
    OUTPUT test4_output
)
_cpp_assert_false(test4_result)
_cpp_assert_exists(${test_prefix}/test4)
_cpp_assert_contains("Hi" "${test4_output}")

#Can change scratch directory used for temp file
set(CMAKE_BINARY_DIR ${test_prefix}/test5)
_cpp_run_cmake_command(
        COMMAND "message(\"Hi\")"
        RESULT test5_result
        BINARY_DIR ${test_prefix}/test5_corr
        OUTPUT test5_output
)

_cpp_assert_false(test5_result)
_cpp_assert_exists(${test_prefix}/test5_corr)
_cpp_assert_does_not_exist(${test_prefix}/test5)
_cpp_assert_contains("Hi" "${test5_output}")

#Crashes if no command is given
_cpp_run_cmake_command(
        COMMAND "_cpp_run_cmake_command()"
        RESULT test6_result
        OUTPUT test6_output
        INCLUDES cpp_cmake_helpers
)
_cpp_assert_true(test6_result)
_cpp_assert_contains("_crcc_cmd_set is set to false value: 0" "${test6_output}")

#Accepts variables
_cpp_run_cmake_command(
    COMMAND "message(\"\${A_VARIABLE} + \${B_VARIABLE}\")"
    RESULT test7_result
    OUTPUT test7_output
    CMAKE_ARGS A_VARIABLE=Hi
               B_VARIABLE=Bye
)
_cpp_assert_false(test7_result)
_cpp_assert_contains("Hi + Bye" "${test7_output}")

################################################################################
# Test _cpp_run_sub_build
################################################################################

#Set-up a little dummy library
set(dummy_root ${test_prefix}/sub_build/dummy)
_cpp_dummy_cxx_library(${dummy_root})
_cpp_write_top_list(
    PATH ${dummy_root}
    NAME dummy
    CONTENTS "add_library(dummy a.cpp)
    set_target_properties(dummy PROPERTIES PUBLIC_HEADER a.hpp)
    install(TARGETS dummy
            LIBRARY DESTINATION lib
            ARCHIVE DESTINATION lib
            RUNTIME DESTINATION bin
            PUBLIC_HEADER DESTINATION include
    )"
)

#Make sure we set that up right
_cpp_assert_exists(${dummy_root})
_cpp_assert_exists(${dummy_root}/a.hpp)
_cpp_assert_exists(${dummy_root}/a.cpp)
_cpp_assert_exists(${dummy_root}/CMakeLists.txt)

#Basic run
set(
    lib_name
    ${CMAKE_SHARED_LIBRARY_PREFIX}dummy${CMAKE_SHARED_LIBRARY_SUFFIX}
)
set(basic_root ${test_prefix}/sub_build/basic)
file(COPY ${dummy_root} DESTINATION ${basic_root})
set(CPP_DEBUG_MODE OFF)
_cpp_run_sub_build(
    ${basic_root}/dummy
    INSTALL_PREFIX ${basic_root}/install
)
_cpp_assert_exists(${basic_root}/install)
_cpp_assert_exists(${basic_root}/install/lib/${lib_name})
_cpp_assert_exists(${basic_root}/install/include/a.hpp)

#No install doesn't install
set(no_install_root ${test_prefix}/sub_build/no_install)
file(COPY ${dummy_root} DESTINATION ${no_install_root})
set(CPP_DEBUG_MODE OFF)
_cpp_run_sub_build(
        ${no_install_root}/dummy
        NO_INSTALL
        INSTALL_PREFIX ${no_install_root}/install
)
_cpp_assert_does_not_exist(${no_install_root}/install)

#Can grab the output
set(output_root ${test_prefix}/sub_build/output)
file(COPY ${dummy_root} DESTINATION ${output_root})
set(CPP_DEBUG_MODE OFF)
_cpp_run_sub_build(
        ${output_root}/dummy
        NO_INSTALL
        OUTPUT output_result
)
#Just look for a few generic lines
_cpp_assert_contains("-- Configuring done" "${output_result}")
_cpp_assert_contains("[100%] Built target dummy" "${output_result}")

#Not providing an install path (and not specifying NO_INSTALL) fails
set(install_fail_root ${test_prefix}/sub_build/install_fail)
file(COPY ${dummy_root} DESTINATION ${install_fail_root})
_cpp_run_cmake_command(
    COMMAND "_cpp_run_sub_build(${install_fail_root}/dummy)"
    RESULT install_fail_result
    OUTPUT install_fail_output
    INCLUDES cpp_cmake_helpers
)
_cpp_assert_true(install_fail_result)
_cpp_assert_contains(
    "_crsb_install_set is set to false value: 0"
    "${install_fail_output}"
)
