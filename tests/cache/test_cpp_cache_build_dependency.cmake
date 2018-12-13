include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_build_env("cache_build_dependency")

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(${src_dir})
_cpp_cache_dummy_cxx_library(${CPP_INSTALL_CACHE} ${src_dir})
_cpp_add_test(
TITLE "Basic usage"
"include(cache/cache_build_dependency)"
"_cpp_cache_build_dependency("
"   ${CPP_INSTALL_CACHE} dummy 1.0 ${CMAKE_TOOLCHAIN_FILE}"
")"
"_cpp_cache_install_path("
"   path ${CPP_INSTALL_CACHE} dummy 1.0 ${CMAKE_TOOLCHAIN_FILE}"
")"
"_cpp_assert_exists(\${path})"
)
