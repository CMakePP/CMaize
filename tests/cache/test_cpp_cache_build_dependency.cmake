include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_build_env("cache_build_dependency")

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(${src_dir})
_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "include(cache/cache_add_dependency)"
    "include(cache/cache_build_dependency)"
    "_cpp_cache_add_dependency("
    "   ${test_prefix} dummy SOURCE_DIR ${src_dir}/dummy"
    ")"
    "_cpp_cache_build_dependency("
    "   ${test_prefix} dummy 1.0 ${CMAKE_TOOLCHAIN_FILE}"
    ")"
    "_cpp_cache_install_path("
    "   path ${test_prefix} dummy 1.0 ${CMAKE_TOOLCHAIN_FILE}"
    ")"
    "_cpp_assert_exists(\${path})"
)
