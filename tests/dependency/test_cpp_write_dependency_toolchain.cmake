include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("write_dependency_toolchain")

set(test_tc ${test_prefix}/${test_number}/test_toolchain.cmake)
_cpp_add_test(
TITLE "No args/depends"
"include(dependency/cpp_write_dependency_toolchain)"
"include(filesystem/filesystem_split_file)"
"_cpp_write_dependency_toolchain(${test_tc} ${CMAKE_TOOLCHAIN_FILE} \"\" \"\")"
"_cpp_split_file(corr_lines ${CMAKE_TOOLCHAIN_FILE})"
"_cpp_split_file(test_lines ${test_tc})"
"list(LENGTH corr_lines corr_length)"
"list(LENGTH test_lines test_length)"
"_cpp_assert_equal(\${corr_length} \${test_length})"
"file(READ ${test_tc} test_buffer)"
"foreach(linei \${corr_lines})"
"    _cpp_assert_contains(\${linei} \${test_buffer})"
"endforeach()"
)

set(test_tc ${test_prefix}/${test_number}/test_toolchain.cmake)
_cpp_add_test(
TITLE "Args no depends"
"include(dependency/cpp_write_dependency_toolchain)"
"include(filesystem/filesystem_split_file)"
"_cpp_write_dependency_toolchain("
"   ${test_tc} ${CMAKE_TOOLCHAIN_FILE} \"Arg1=value1\" \"\""
")"
"_cpp_split_file(corr_lines ${CMAKE_TOOLCHAIN_FILE})"
"_cpp_split_file(test_lines ${test_tc})"
"list(LENGTH corr_lines corr_length)"
"math(EXPR corr_length \"\${corr_length} + 1\")"
"list(LENGTH test_lines test_length)"
"_cpp_assert_equal(\${corr_length} \${test_length})"
"file(READ ${test_tc} test_buffer)"
"foreach(linei \${corr_lines})"
"    _cpp_assert_contains(\${linei} \${test_buffer})"
"endforeach()"
"_cpp_assert_contains(Arg1 \${test_buffer})"
"_cpp_assert_contains(value1 \${test_buffer})"
)

set(test_tc ${test_prefix}/${test_number}/test_toolchain.cmake)
_cpp_add_test(
TITLE "Depend with DIR, but no args"
"include(dependency/cpp_write_dependency_toolchain)"
"include(filesystem/filesystem_split_file)"
"add_library(_cpp_dummy_External INTERFACE)"
"set_target_properties("
"   _cpp_dummy_External"
"   PROPERTIES INTERFACE_INCLUDE_DIRECTORIES \"dummy_DIR value\""
")"
"_cpp_write_dependency_toolchain("
"   ${test_tc} ${CMAKE_TOOLCHAIN_FILE} \"\" \"dummy\""
")"
"_cpp_split_file(corr_lines ${CMAKE_TOOLCHAIN_FILE})"
"_cpp_split_file(test_lines ${test_tc})"
"list(LENGTH corr_lines corr_length)"
        "math(EXPR corr_length \"\${corr_length} + 1\")"
        "list(LENGTH test_lines test_length)"
        "_cpp_assert_equal(\${corr_length} \${test_length})"
        "file(READ ${test_tc} test_buffer)"
        "foreach(linei \${corr_lines})"
        "    _cpp_assert_contains(\${linei} \${test_buffer})"
        "endforeach()"
        "_cpp_assert_contains(dummy_DIR \${test_buffer})"
        "_cpp_assert_contains(dummy \${test_buffer})"
)

set(test_tc ${test_prefix}/${test_number}/test_toolchain.cmake)
_cpp_add_test(
TITLE "Depend with ROOT, but no args"
"include(dependency/cpp_write_dependency_toolchain)"
"include(filesystem/filesystem_split_file)"
"add_library(_cpp_dummy_External INTERFACE)"
"set_target_properties("
"   _cpp_dummy_External"
"   PROPERTIES INTERFACE_INCLUDE_DIRECTORIES \"dummy_ROOT value\""
")"
"_cpp_write_dependency_toolchain("
"   ${test_tc} ${CMAKE_TOOLCHAIN_FILE} \"\" \"dummy\""
")"
"_cpp_split_file(corr_lines ${CMAKE_TOOLCHAIN_FILE})"
"_cpp_split_file(test_lines ${test_tc})"
"list(LENGTH corr_lines corr_length)"
"math(EXPR corr_length \"\${corr_length} + 1\")"
"list(LENGTH test_lines test_length)"
"_cpp_assert_equal(\${corr_length} \${test_length})"
"file(READ ${test_tc} test_buffer)"
"foreach(linei \${corr_lines})"
"    _cpp_assert_contains(\${linei} \${test_buffer})"
"endforeach()"
"_cpp_assert_contains(dummy_ROOT \${test_buffer})"
"_cpp_assert_contains(dummy \${test_buffer})"
)
