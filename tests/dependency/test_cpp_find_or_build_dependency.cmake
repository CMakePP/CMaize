include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_or_build_dependency")

_cpp_add_test(
TITLE "Crashes if NAME not set"
SHOULD_FAIL REASON "Required option _cfobd_NAME is not set"
CONTENTS "cpp_find_or_build_dependency()"
)


_cpp_install_dummy_cxx_package(${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Finds existing dependency"
CONTENTS
    "set(dummy_ROOT ${test_prefix}/${test_number}/install)"
    "cpp_find_or_build_dependency(NAME dummy)"
    "_cpp_assert_target_property("
    "   _cpp_dummy_External"
    "   INTERFACE_VERSION"
    "   \"cpp_find_or_build_dependency(\n    NAME dummy\n)\""
")"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(${src_dir})
set(src_dir ${src_dir}/dummy)

set(prefix "cpp_find_or_build_dependency(\n    NAME dummy\n")
_cpp_add_test(
TITLE "Basic local usage"
CONTENTS
    "cpp_find_or_build_dependency(
    "   NAME dummy
    "   SOURCE_DIR ${src_dir}"
    ")"
    "_cpp_assert_target_property("
    "   _cpp_dummy_External"
    "   INTERFACE_VERSION"
    "   \"${prefix}    SOURCE_DIR ${src_dir}\n)\""
    ")"
)

set(prefix "cpp_find_or_build_dependency(\n    NAME cpp\n")
set(url github.com/CMakePackagingProject/CMakePackagingProject)
_cpp_add_test(
TITLE "Basic URL usage"
CONTENTS
    "cpp_find_or_build_dependency(NAME cpp URL ${url})"
    "_cpp_assert_target_property("
    "   _cpp_cpp_External"
    "   INTERFACE_VERSION"
    "   \"${prefix}    URL ${url}\n)\""
    ")"
)
