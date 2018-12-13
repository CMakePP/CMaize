include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("run_sub_build")

_cpp_dummy_cxx_package(${test_prefix}/${test_number})
set(src_dir ${test_prefix}/${test_number}/dummy)

_cpp_add_test(
TITLE "Errs if NAME is not specified"
SHOULD_FAIL REASON "Required option _crsb_NAME is not set"
"include(cpp_cmake_helpers)"
"_cpp_run_sub_build(${src_dir})"
)

_cpp_dummy_cxx_package(${test_prefix}/${test_number})
set(src_dir ${test_prefix}/${test_number}/dummy)
_cpp_add_test(
TITLE "Basic usage"
"include(cpp_cmake_helpers)"
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
"include(cpp_cmake_helpers)"
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
"include(cpp_cmake_helpers)"
"_cpp_run_sub_build("
"   ${src_dir}"
"   NAME dummy"
"   INSTALL_DIR ${test_prefix}/${test_number}/install"
")"
"_cpp_assert_does_not_exist(${src_dir}/install)"
"_cpp_assert_exists(${test_prefix}/${test_number}/install)"
)

set(src_dir ${test_prefix}/${test_number})
file(
    WRITE ${src_dir}/test/CMakeLists.txt
"include(cpp_assert)
 _cpp_assert_equal(\"\${option1}\" 33)
 _cpp_assert_equal(\"\${option2}\" 44)
"
)
_cpp_add_test(
TITLE "Honors CMAKE_ARGS"
"include(cpp_cmake_helpers)"
"_cpp_run_sub_build("
"   ${src_dir}/test"
"   NAME dummy"
"   NO_BUILD"
"   CMAKE_ARGS option1=33"
"              option2=44"
")"
)
