include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("provided_lists")

# In this scenario a user has provided the cmake command with a variable that
# contains a list.  For the present test that varible is CMAKE_PRFEIX_PATH
# CPP needs to correctly forward that list so that the resulting toolchain file
# contains the list.

#Start by making a CPP repo
_cpp_dummy_cxx_package(${test_prefix}/${test_number})

#This should be where CPP puts the toolchain
set(result_tc_file ${test_prefix}/1/dummy/build/toolchain.cmake)

_cpp_add_test(
TITLE "Pass a list on the command line"
CONTENTS
    "execute_process("
    "   COMMAND ${CMAKE_COMMAND} -H. -Bbuild"
    "           -DCMAKE_PREFIX_PATH=\"/a/path/1\\\\\;/a/path/2\""
    "   WORKING_DIRECTORY ${test_prefix}/${test_number}/dummy"
    ")"
)
