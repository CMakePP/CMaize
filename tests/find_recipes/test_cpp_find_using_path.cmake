include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_using_path")
set(empty "") #Need to preserve indents
set(contents
"list(APPEND CMAKE_PREFIX_PATH /a/path)
find_package(
    test
    ${empty}
    ${empty}
    CONFIG
    QUIET
    NO_PACKAGE_ROOT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
)
")


_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "include(cpp_find_recipes)"
    "_cpp_find_using_path(test test \"\" \"\" \"/a/path\")"
    "_cpp_assert_equal(\"${contents}\" \"\${test}\")"
)

set(contents
"list(APPEND CMAKE_PREFIX_PATH /a/path)
find_package(
    test
    1.0
    COMPONENTS comp1 comp2
    CONFIG
    QUIET
    NO_PACKAGE_ROOT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
)
")


_cpp_add_test(
TITLE "Honors components and version"
CONTENTS
    "include(cpp_find_recipes)"
    "_cpp_find_using_path(test test 1.0 \"COMPONENTS comp1 comp2\" \"/a/path\")"
    "_cpp_assert_equal(\"${contents}\" \"\${test}\")"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Finds installed dependency at the specified path"
CONTENTS
    "include(cpp_find_recipes)"
    "_cpp_find_using_path(test dummy \"\" \"\" \"${src_dir}/install\")"
    "file(WRITE ${src_dir}/find-dummy.cmake \"\${test}\")"
    "include(${src_dir}/find-dummy.cmake)"
    "_cpp_assert_true(dummy_FOUND)"
    "_cpp_assert_equal("
    "   \"${src_dir}/install/share/cmake/dummy/dummy-config.cmake\""
    "   \"\${dummy_CONFIG}\""
    ")"
)
