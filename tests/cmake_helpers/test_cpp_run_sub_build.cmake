include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("run_sub_build")

_cpp_dummy_cxx_package(${test_prefix}/${test_number})
set(src_dir ${test_prefix}/${test_number}/dummy)

_cpp_add_test(
TITLE "Errs if NAME is not specified"
SHOULD_FAIL REASON "Required option _crsb_NAME is not set"
CONTENTS
    "_cpp_run_sub_build(${src_dir})"
)

_cpp_dummy_cxx_package(${test_prefix}/${test_number})
set(src_dir ${test_prefix}/${test_number}/dummy)
_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "_cpp_run_sub_build("
    "   ${src_dir}"
    "   NAME dummy"
    "   RESULT failed"
    ")"
    "_cpp_assert_exists(${src_dir}/build)"
    "_cpp_assert_exists(${src_dir}/install)"
    "_cpp_assert_false(\${failed})"
)

_cpp_dummy_cxx_package(${test_prefix}/${test_number})
set(src_dir ${test_prefix}/${test_number}/dummy)
_cpp_add_test(
TITLE "Honors BINARY_DIR"
CONTENTS
    "_cpp_run_sub_build("
    "   ${src_dir}"
    "   NAME dummy"
    "   BINARY_DIR ${test_prefix}/${test_number}/build"
    ")"
    "_cpp_assert_does_not_exist(${src_dir}/build)"
    "_cpp_assert_exists(${test_prefix}/${test_number}/build)"
)

_cpp_dummy_cxx_package(${test_prefix}/${test_number})
set(src_dir ${test_prefix}/${test_number}/dummy)
_cpp_add_test(
TITLE "Honors INSTALL_DIR"
CONTENTS
"_cpp_run_sub_build("
"   ${src_dir}"
"   NAME dummy"
"   INSTALL_DIR ${test_prefix}/${test_number}/install"
")"
"_cpp_assert_does_not_exist(${src_dir}/install)"
"_cpp_assert_exists(${test_prefix}/${test_number}/install)"
)

file(
    WRITE ${test_prefix}/${test_number}/test_toolchain.cmake
    "set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH})\nset(foo bar)"
)
set(src_dir ${test_prefix}/${test_number})
_cpp_run_sub_build(
   ${src_dir}
   NAME dummy
   NO_INSTALL
   TOOLCHAIN ${src_dir}/test_toolchain.cmake
   CONTENTS
       "_cpp_assert_equal(bar \"\${foo}\")"
       "_cpp_assert_file_contains("
       "    \"set(foo bar)\""
       "    \${CMAKE_TOOLCHAIN_FILE}"
       ")"
   OUTPUT test_output
)
message("${test_output}")
