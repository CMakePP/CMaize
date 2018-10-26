include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers.cmake)
include(cpp_dependency)
include(cpp_assert)
set(CPP_DEBUG_MODE ON)
_cpp_setup_build_env("build_local_dependency")

#Set up dummy package
_cpp_dummy_cxx_package(${test_prefix})

################################################################################
# Test basic usage
################################################################################

_cpp_build_local_dependency(
    NAME dummy
    SOURCE_DIR ${test_prefix}/dummy
    BINARY_DIR ${test_prefix}/test1
    INSTALL_DIR ${test_prefix}/test1/install
)

verify_dummy_install(${test_prefix}/test1/install)

################################################################################
# Test TOOLCHAIN honored
################################################################################

#Need to allow passing of toolchain to run_sub_build for this to work

#set(temp_tc ${CMAKE_TOOLCHAIN_FILE})
#set(CMAKE_TOOLCHAIN_FILE "")
#_cpp_build_local_dependency(
#    NAME dummy
#    SOURCE_DIR ${test_prefix}/dummy
#    BINARY_DIR ${test_prefix}/test2
#    INSTALL_DIR ${test_prefix}/test2/install
#    TOOLCHAIN ${temp_tc}
#)
verify_dummy_install(${test_prefix}/test2/install)
#set(CMAKE_TOOLCHAIN_FILE ${temp_tc})

################################################################################
# Test fails if NAME not set
################################################################################

_cpp_test_build_fails(
    NAME test3
    PATH ${test_prefix}/test3
    CONTENTS "include(cpp_dependency)
              _cpp_build_local_dependency(
                  SOURCE_DIR ${test_prefix}/dummy
                  BINARY_DIR ${test_prefix}/test3
                  INSTALL_DIR ${test_prefix}/test3/install
              )"
    REASON "_cbld_NAME is set to false value:"
)

################################################################################
# Test fails if SOURCE_DIR is not set
################################################################################

_cpp_test_build_fails(
    NAME test4
    PATH ${test_prefix}/test4
    CONTENTS "include(cpp_dependency)
              _cpp_build_local_dependency(
                  NAME dummy
                  BINARY_DIR ${test_prefix}/test4
                  INSTALL_DIR ${test_prefix}/test4/install
              )"
        REASON "_cbld_SOURCE_DIR is set to false value:"
)

################################################################################
# Test fails if INSTALL_DIR is not set
################################################################################

_cpp_test_build_fails(
    NAME test5
    PATH ${test_prefix}/test5
    CONTENTS "include(cpp_dependency)
             _cpp_build_local_dependency(
                  NAME dummy
                  SOURCE_DIR ${test_prefix}/dummy
                  BINARY_DIR ${test_prefix}/test5
              )"
        REASON "_cbld_INSTALL_DIR is set to false value:"
)
