include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("write_list")

set(
    common_header
    "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n"
)
set(
    common_header
    "${common_header}project(0 VERSION 0.0.0)\ninclude(CPPMain)\nCPPMain()\n"
)

set(test_dir ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Basic usage: file exists"
CONTENTS
    "_cpp_write_list("
    "   ${test_dir}/dummy"
    "   NAME 0"
    "   CONTENTS \"set(A_VARIABLE just_a_string)\""
    ")"
    "_cpp_assert_exists(${test_dir}/dummy/CMakeLists.txt)"
)

_cpp_add_test(
TITLE "Basic usage: contents correct"
CONTENTS
    "_cpp_assert_file_contains("
    "   \"${common_header}set(A_VARIABLE just_a_string)\""
    "   ${test_dir}/dummy/CMakeLists.txt"
    ")"
)

_cpp_add_test(
TITLE "Fails if NAME is not specified"
SHOULD_FAIL REASON "Required option _cwl_NAME is not set"
CONTENTS "_cpp_write_list(${test_dir})"
)

set(test_dir ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Can pass a variable"
CONTENTS
    "_cpp_write_list("
    "   ${test_dir}/dummy"
    "   NAME 0"
    "   CONTENTS \"set(A_VARIABLE just_a_string)\""
    "            \"set(B_VARIABLE \\\${A_VARIABLE})\""
    ")"
)

#Test needs to be outside otherwise the test gets parsed the same way
_cpp_assert_file_contains(
    "\${A_VARIABLE}"
    ${test_dir}/dummy/CMakeLists.txt
)
