include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_add_dependency)
_cpp_setup_build_env("special_find")

set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})
_cpp_cache_add_dependency(${src_dir} dummy SOURCE_DIR ${src_dir}/dummy)

_cpp_add_test(
TITLE "If variables not set, found is false"
CONTENTS
    "include(dependency/cpp_special_find)"
    "_cpp_special_find(dummy_FOUND ${src_dir} dummy \"\" \"\")"
    "_cpp_assert_false(dummy_FOUND)"
)

foreach(var dummy_ROOT DUMMY_ROOT)
    _cpp_add_test(
    TITLE "Can find package via: ${var}"
    CONTENTS
        "include(dependency/cpp_special_find)"
        "set(${var} ${src_dir}/install)"
        "_cpp_special_find(dummy_FOUND ${src_dir} dummy \"\" \"\")"
        "_cpp_assert_true(dummy_FOUND)"
    )
    _cpp_add_test(
    TITLE "Bad ${var} is an error"
    SHOULD_FAIL REASON "${var} set, but dummy not found there"
    CONTENTS
        "include(dependency/cpp_special_find)"
        "set(${var} /not/a/path)"
        "_cpp_special_find(dummy_FOUND ${src_dir} dummy \"\" \"\")"
    )
endforeach()
