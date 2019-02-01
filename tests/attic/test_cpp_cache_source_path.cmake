include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_paths)
_cpp_setup_test_env("cache_source_path")

_cpp_add_test(
TITLE "Set to NOTFOUND if tarball DNE"
CONTENTS
    "include(cache/cache_paths)"
    "_cpp_cache_source_path(output ${test_prefix} dummy \"\")"
    "_cpp_assert_equal(\"output-NOTFOUND\" \"\${output}\")"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_cache_tarball_path(version ${src_dir} dummy 1.0)
_cpp_cache_tarball_path(no_version ${src_dir} dummy "")
file(WRITE ${version} "hi")
file(WRITE ${no_version} "hi")
file(SHA1 ${version} hash)
set(corr ${src_dir}/dummy/${hash}/source)

_cpp_add_test(
TITLE "Works for version"
CONTENTS
    "include(cache/cache_paths)"
    "_cpp_cache_source_path(output ${src_dir} dummy 1.0)"
    "_cpp_assert_equal(\"${corr}\" \"\${output}\")"
)

_cpp_add_test(
TITLE "Works for no version"
CONTENTS
    "include(cache/cache_paths)"
    "_cpp_cache_source_path(output ${src_dir} dummy \"\")"
    "_cpp_assert_equal(\"${corr}\" \"\${output}\")"
)
