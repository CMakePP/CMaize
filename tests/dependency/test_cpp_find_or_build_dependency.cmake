include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_or_build_dependency")

_cpp_add_test(
TITLE "Crashes if NAME not set"
SHOULD_FAIL REASON "Required option _cKpa_NAME is not set"
"include(dependency/cpp_find_or_build_dependency)"
"cpp_find_or_build_dependency()"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(src_dir ${src_dir})

_cpp_add_test(
TITLE "Build from local source dir."
"include(dependency/cpp_find_or_build_dependency)"
"cpp_find_or_build_dependency(
"   NAME dummy
"   SOURCE_DIR ${src_dir}"
")"
)

set(url github.com/CMakePackagingProject/CMakePackagingProject)
_cpp_add_test(
TITLE "Build from URL."
"include(dependency/cpp_find_or_build_dependency)"
"cpp_find_or_build_dependency(NAME cpp URL ${url})"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_naive_cxx_package(root_dir ${src_dir} NAME dummy2)
_cpp_naive_find_module(module ${src_dir} NAME dummy2)

_cpp_add_test(
TITLE "Find from find module."
"include(dependency/cpp_find_or_build_dependency)"
"cpp_find_or_build_dependency("
"   NAME dummy2"
"   SOURCE_DIR ${root_dir}"
"   FIND_MODULE ${module}"
")"
)
