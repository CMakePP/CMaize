include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("write_toolchain")

_cpp_add_test(
TITLE "Sets CMAKE_TOOLCHAIN_FILE"
CONTENTS
    "_cpp_write_toolchain_file()"
    "_cpp_assert_equal(\"\${CMAKE_TOOLCHAIN_FILE}\""
    "                  \"\${CMAKE_BINARY_DIR}/toolchain.cmake\")"
)

_cpp_add_test(
TITLE "Honors DESTINATION"
CONTENTS
    "_cpp_write_toolchain_file(DESTINATION ${test_prefix}/${test_number})"
    "_cpp_assert_exists(${test_prefix}/${test_number}/toolchain.cmake)"
    "_cpp_assert_equal("
    "   ${test_prefix}/${test_number}/toolchain.cmake"
    "   \${CMAKE_TOOLCHAIN_FILE}"
    ")"
)

_cpp_add_test(
TITLE "Does not write empty variables"
CONTENTS
    "set(CMAKE_C_COMPILER \"\")"
    "_cpp_write_toolchain_file(DESTINATION ${test_prefix}/${test_number})"
    "_cpp_assert_file_does_not_contain(\"set(CMAKE_C_COMPILER\""
    "                                  \${CMAKE_TOOLCHAIN_FILE})"
)

set(test_dir ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Can write lists"
CONTENTS
    "set(CMAKE_PREFIX_PATH /a/path/1 /a/path/2)"
    "_cpp_write_toolchain_file(DESTINATION ${test_dir})"
)
_cpp_assert_file_contains(
    "set(CMAKE_PREFIX_PATH \"/a/path/1;/a/path/2\")"
    "${test_dir}/toolchain.cmake"
)
