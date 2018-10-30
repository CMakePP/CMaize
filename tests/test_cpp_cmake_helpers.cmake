include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(../cmake/cpp_unit_test_helpers.cmake)

_cpp_setup_build_env(cpp_cmake_helpers)


################################################################################
# Test _cpp_write_top_list
################################################################################

#Basic usage
_cpp_write_top_list(
    ${test_prefix}/top_list
    top_list_test
    "Hi"
)
_cpp_assert_exists(${test_prefix}/top_list/CMakeLists.txt)
file(READ ${test_prefix}/top_list/CMakeLists.txt test1_contents)
set(test1_corr
"cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(top_list_test VERSION 0.0.0)
include(CPPMain)
CPPMain()
Hi"
)
_cpp_assert_equal("${test1_contents}" "${test1_corr}")

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
set(
    dummy_contents
    "add_library(dummy a.cpp)
    set_target_properties(dummy PROPERTIES PUBLIC_HEADER a.hpp)
    install(TARGETS dummy
            LIBRARY DESTINATION lib
            ARCHIVE DESTINATION lib
            RUNTIME DESTINATION bin
            PUBLIC_HEADER DESTINATION include
    )"
)

#Basic run
set(
    lib_name
    ${CMAKE_SHARED_LIBRARY_PREFIX}dummy${CMAKE_SHARED_LIBRARY_SUFFIX}
)
set(basic_root ${test_prefix}/sub_build/basic/dummy)
_cpp_dummy_cxx_library(${basic_root})

_cpp_run_sub_build(
    ${basic_root}
    CONTENTS "${dummy_contents}"
    NAME dummy
    INSTALL_PREFIX ${basic_root}/install
)
_cpp_assert_exists(${basic_root}/install)
_cpp_assert_exists(${basic_root}/install/lib/${lib_name})
_cpp_assert_exists(${basic_root}/install/include/a.hpp)

#No install doesn't install
set(no_install_root ${test_prefix}/sub_build/no_install/dummy)
_cpp_dummy_cxx_library(${no_install_root})
_cpp_run_sub_build(
        ${no_install_root}
        CONTENTS "${dummy_contents}"
        NAME dummy
        NO_INSTALL
        INSTALL_PREFIX ${no_install_root}/install
)
_cpp_assert_does_not_exist(${no_install_root}/install)

#Can grab the output
set(output_root ${test_prefix}/sub_build/output/dummy)
_cpp_dummy_cxx_library(${output_root})
_cpp_run_sub_build(
        ${output_root}
        NO_INSTALL
        CONTENTS "${dummy_contents}"
        NAME dummy
        OUTPUT output_result
)
#Just look for a few generic lines
_cpp_assert_contains("-- Configuring done" "${output_result}")
_cpp_assert_contains("[100%] Built target dummy" "${output_result}")

#Not providing an install path (and not specifying NO_INSTALL) fails
set(install_fail_root ${test_prefix}/sub_build/install_fail/dummy)
_cpp_dummy_cxx_library(${install_fail_root})
_cpp_test_build_fails(
    PATH ${install_fail_root}
    NAME dummy
    CONTENTS "include(cpp_cmake_helpers)
              _cpp_run_sub_build(
                  ${install_fail_root}
                  NAME dummy
                  CONTENTS ${dummy_contents}
             )"
    REASON "_crsb_install_set is set to false value: 0"
)
