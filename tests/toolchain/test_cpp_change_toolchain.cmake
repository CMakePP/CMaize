include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("change_toolchain")

set(test_dir ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "_cpp_write_toolchain_file(DESTINATION ${test_dir})"
    "_cpp_change_toolchain(CMAKE_ARGS CMAKE_CXX_COMPILER=new_CXX_value)"
    "_cpp_assert_file_contains(\"new_CXX_value\""
    "                          \"${test_dir}/toolchain.cmake\")"
)

set(test_dir ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Change non-existing variable"
CONTENTS
    "_cpp_write_toolchain_file(DESTINATION ${test_dir})"
    "_cpp_change_toolchain(CMAKE_ARGS NOT_A_VARIABLE=not_a_value)"
    "_cpp_assert_file_contains(\"NOT_A_VARIABLE\""
    "                          \"${test_dir}/toolchain.cmake\")"
    "_cpp_assert_file_contains(\"not_a_value\""
    "                          \"${test_dir}/toolchain.cmake\")"
)

set(test_dir ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Modify multiple values"
CONTENTS
    "_cpp_write_toolchain_file(DESTINATION ${test_dir})"
    "_cpp_change_toolchain(CMAKE_ARGS CMAKE_CXX_COMPILER=new_cxx_compiler"
    "                                 CMAKE_C_COMPILER=new_c_compiler)"
    "_cpp_assert_file_contains(\"new_cxx_compiler\""
    "                          \"${test_dir}/toolchain.cmake\")"
    "_cpp_assert_file_contains(\"new_c_compiler\""
    "                          \"${test_dir}/toolchain.cmake\")"
)

set(test_dir ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Honors TOOLCHAIN"
CONTENTS
    "_cpp_write_toolchain_file(DESTINATION ${test_dir})"
    "set(CMAKE_TOOLCHAIN_FILE \"\")"
    "_cpp_change_toolchain(TOOLCHAIN ${test_dir}/toolchain.cmake"
    "                      CMAKE_ARGS NOT_A_VARIABLE=not_a_value)"
    "_cpp_assert_file_contains(\"NOT_A_VARIABLE\""
    "                          \"${test_dir}/toolchain.cmake\")"
    "_cpp_assert_file_contains(\"not_a_value\""
    "                          \"${test_dir}/toolchain.cmake\")"
)

set(test_dir ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Writes toolchain if it DNE"
CONTENTS
    "_cpp_change_toolchain(TOOLCHAIN ${test_dir}/toolchain.cmake)"
    "_cpp_assert_exists(${test_dir}/toolchain.cmake)"
)
