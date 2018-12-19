include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("provided_toolchain")

# In this scenario a user is providing a CPP project a toolchain and that
# toolchain only sets some variables.  CPP needs to set the remaining variables
# and forward the resulting merged toolchain

#Start by making a CPP repo
_cpp_dummy_cxx_package(${test_prefix}/${test_number})

#This is our user-provided toolchain
set(tc_file ${test_prefix}/test_toolchain.cmake)

#Now we write a toolchain that changes where CPP's Cache is.  We also need to
#set CMAKE_MODULE_PATH so CPP is findable; this is quirk of testing from within
#CPP, where we don't have an installed version to use. Real use cases would
#have CMAKE_MODULE_PATH set by find_package(cpp)
file(
    WRITE ${tc_file}
    "set(CPP_INSTALL_CACHE ${test_prefix}/test_cache)
     set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH})"
)

#This should be where CPP puts the merged toolchain
set(result_tc_file ${test_prefix}/${test_number}/dummy/build/toolchain.cmake)

_cpp_add_test(
TITLE "Writes a new toolchain"
CONTENTS
    "execute_process("
    "   COMMAND ${CMAKE_COMMAND} -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE=${tc_file}"
    "   WORKING_DIRECTORY ${test_prefix}/${test_number}/dummy"
    ")"
    "_cpp_assert_exists(${result_tc_file})"
)

_cpp_add_test(
TITLE "Contains our new cache"
CONTENTS
    "_cpp_assert_file_contains("
    "   \"set(CPP_INSTALL_CACHE \\\"${test_prefix}/test_cache\\\"\""
    "   ${result_tc_file}"
    ")"
)

_cpp_add_test(
TITLE "Contains variables we didn't set"
CONTENTS
    "_cpp_assert_file_contains("
    "   \"set(CMAKE_CXX_COMPILER\""
    "   ${result_tc_file}"
    ")"
)
