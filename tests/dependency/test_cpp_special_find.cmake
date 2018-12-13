include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_add_dependency)
_cpp_setup_build_env("special_find")

set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})
_cpp_cache_write_find_recipe(${src_dir} dummy "")
_cpp_cache_find_recipe(recipe ${src_dir} dummy)

foreach(var dummy_ROOT DUMMY_ROOT)
    _cpp_add_test(
    TITLE "Can find package via: ${var}"
    CONTENTS
        "include(dependency/cpp_special_find)"
        "set(${var} ${src_dir}/install)"
        "_cpp_special_find(found dummy ${recipe} \"\" \"\")"
        "_cpp_assert_true(found)"
    )
    _cpp_add_test(
    TITLE "Bad ${var} is an error"
    SHOULD_FAIL
    REASON "Variable ${var} set to /not/a/path, but dummy was not found there."
    CONTENTS
        "include(dependency/cpp_special_find)"
        "set(${var} /not/a/path)"
        "_cpp_special_find(found dummy ${recipe} \"\" \"\")"
    )
endforeach()
