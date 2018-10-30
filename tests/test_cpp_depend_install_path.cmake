include(${CMAKE_TOOLCHAIN_FILE})
include(../cmake/cpp_unit_test_helpers.cmake)
include(cpp_dependency)
include(cpp_assert)
set(CPP_DEBUG_MODE ON)

#Set-up test and get typical Toolchain's hash
_cpp_setup_build_env("cpp_depend_install_path")
file(SHA1 ${CMAKE_TOOLCHAIN_FILE} toolchain_hash)


#Make a dummy library and get its hash
_cpp_dummy_cxx_library(${test_prefix}/dummy)
execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar "cf" "${test_prefix}/dummy.tar"
    "${test_prefix}/dummy"
)
file(SHA1 ${test_prefix}/dummy.tar source_hash)

################################################################################
# Basic usage test
################################################################################

_cpp_depend_install_path(test1 NAME dummy SOURCE_DIR ${test_prefix}/dummy)
_cpp_assert_equal(
    "${test_prefix}/cpp_cache/dummy/${source_hash}/${toolchain_hash}"
    "${test1}"
)

################################################################################
# Test that TOOLCHAIN is honored
################################################################################

file(WRITE ${test_prefix}/test2/toolchain.cmake "hi")
file(SHA1  ${test_prefix}/test2/toolchain.cmake test2_hash)
_cpp_depend_install_path(
    test2
    NAME dummy
    SOURCE_DIR ${test_prefix}/dummy
    TOOLCHAIN ${test_prefix}/test2/toolchain.cmake
)
_cpp_assert_equal(
    "${test_prefix}/cpp_cache/dummy/${source_hash}/${test2_hash}"
    "${test2}"
)

################################################################################
# Test that NAME is honored
################################################################################

_cpp_depend_install_path(test3 NAME dummy2 SOURCE_DIR ${test_prefix}/dummy)
_cpp_assert_equal(
    "${test_prefix}/cpp_cache/dummy2/${source_hash}/${toolchain_hash}"
    "${test3}"
)

################################################################################
# Test that CPP_CACHE is honored
################################################################################

_cpp_depend_install_path(
    test4
    NAME dummy
    SOURCE_DIR ${test_prefix}/dummy
    CPP_CACHE ${test_prefix}/test4
)
_cpp_assert_equal(
    "${test_prefix}/test4/dummy/${source_hash}/${toolchain_hash}"
    "${test4}"
)

################################################################################
# Not setting NAME is a failure
################################################################################

_cpp_test_build_fails(
    NAME test5
    PATH ${test_prefix}/test5
    CONTENTS "include(cpp_dependency)
              _cpp_depend_install_path(test5_hash)"
    REASON "_cdip_NAME is set to false value:"
)

################################################################################
# Not setting SOURCE_DIR is a failure
################################################################################

_cpp_test_build_fails(
        NAME test6
        PATH ${test_prefix}/test6
        CONTENTS "include(cpp_dependency)
              _cpp_depend_install_path(test6_hash NAME dummy)"
        REASON "_cdip_SOURCE_DIR is set to false value:"
)
