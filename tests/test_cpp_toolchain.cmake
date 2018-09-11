include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_toolchain)
include(cpp_unit_test_helpers.cmake)

#We're testing our ability to generate it so unset the variable now that we
#loaded it (need CMAKE_MODULE_PATH from it)
set(CMAKE_TOOLCHAIN_FILE)

_cpp_setup_build_env("cpp_toolchain")

#These are non-compiler toolchain variables and fake defaults for them
set(CMAKE_SYSTEM_NAME System)
set(CMAKE_MODULE_PATH "")
set(BUILD_SHARED_LIBS FALSE)
set(CPP_LOCAL_CACHE /a/path)
set(common_contents
"set(CMAKE_SYSTEM_NAME \"System\")
set(BUILD_SHARED_LIBS \"FALSE\")
set(CPP_LOCAL_CACHE \"/a/path\")
"
)

set(CMAKE_BINARY_DIR ${test_prefix})

################################################################################
# Test1: Default Behavior
################################################################################

# We're mainly looking for the path defaults to CMAKE_BINARY_DIR/toolchain.cmake
_cpp_write_toolchain_file()
_cpp_assert_str_equal(
    "${CMAKE_TOOLCHAIN_FILE}" "${test_prefix}/toolchain.cmake"
)

file(READ ${test_prefix}/toolchain.cmake test1_file)
_cpp_assert_str_equal("${common_contents}" "${test1_file}")

################################################################################
# Test2: Change creation location with DESTINATION
################################################################################

_cpp_make_random_dir(test2_prefix ${test_prefix})
_cpp_write_toolchain_file(DESTINATION ${test2_prefix})
_cpp_assert_str_equal(
        "${CMAKE_TOOLCHAIN_FILE}" "${test2_prefix}/toolchain.cmake"
)
file(READ ${test2_prefix}/toolchain.cmake test2_file)
_cpp_assert_str_equal("${common_contents}" "${test2_file}")

################################################################################
# Test3: Detects compilers
################################################################################
