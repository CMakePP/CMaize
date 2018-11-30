include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
include(cpp_compression)
_cpp_setup_build_env("cache_add_source")

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(${src_dir})
_cpp_cache_tarball_path(no_version ${test_prefix} dummy "")
_cpp_cache_tarball_path(version ${test_prefix} dummy 1.0)
_cpp_tar_directory(${version} ${src_dir}/dummy)
_cpp_tar_directory(${no_version} ${src_dir})
_cpp_cache_source_path(version ${test_prefix} dummy 1.0)
_cpp_cache_source_path(no_version ${test_prefix} dummy "")

_cpp_add_test(
TITLE "Add version source"
CONTENTS
    "include(cache/cache_source)"
    "_cpp_assert_does_not_exist(${version})"
    "_cpp_cache_add_source(${test_prefix} dummy 1.0)"
    "_cpp_assert_exists(${version})"
)

_cpp_add_test(
TITLE "Add unversioned source"
CONTENTS
    "include(cache/cache_source)"
    "_cpp_assert_does_not_exist(${no_version})"
    "_cpp_cache_add_source(${test_prefix} dummy \"\")"
    "_cpp_assert_exists(${version})"
)

_cpp_add_test(
TITLE "Repeated calls with same source are okay"
CONTENTS
    "include(cache/cache_source)"
    "_cpp_assert_exists(${version})"
    "_cpp_cache_add_source(${test_prefix} dummy 1.0)"
    "_cpp_assert_exists(${version})"
)
