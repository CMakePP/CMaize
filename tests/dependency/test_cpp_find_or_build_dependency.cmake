include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_or_build_dependency")
set(suffix "\n    CPP_CACHE ${CPP_INSTALL_CACHE}\n)")
_cpp_add_test(
TITLE "Crashes if NAME not set"
SHOULD_FAIL REASON "Required option _cfobd_NAME is not set"
CONTENTS
    "include(dependency/cpp_find_or_build_dependency)"
    "cpp_find_or_build_dependency()"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(${src_dir})
set(src_dir ${src_dir}/dummy)

set(prefix "cpp_find_or_build_dependency(\n")
set(prefix "${prefix}    NAME dummy\n")
set(prefix "${prefix}    SOURCE_DIR ${src_dir}${suffix}")
_cpp_add_test(
TITLE "Basic local usage:target set"
CONTENTS
    "include(dependency/cpp_find_or_build_dependency)"
    "cpp_find_or_build_dependency(
    "   NAME dummy
    "   SOURCE_DIR ${src_dir}"
    ")"
    "_cpp_assert_target_property("
    "   _cpp_dummy_External"
    "   INTERFACE_VERSION"
    "   \"${prefix}\""
    ")"
)

set(url github.com/CMakePackagingProject/CMakePackagingProject)
set(prefix "cpp_find_or_build_dependency(\n")
set(prefix "${prefix}    NAME cpp\n")
set(prefix "${prefix}    URL ${url}${suffix}")
_cpp_add_test(
TITLE "Basic URL usage:target set"
CONTENTS
    "include(dependency/cpp_find_or_build_dependency)"
    "cpp_find_or_build_dependency(NAME cpp URL ${url})"
    "_cpp_assert_target_property("
    "   _cpp_cpp_External"
    "   INTERFACE_VERSION"
    "   \"${prefix}\""
    ")"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_naive_cxx_package(root_dir install_dir ${src_dir} NAME dummy2)
_cpp_naive_find_module(module ${src_dir} NAME dummy2)
set(url github.com/CMakePackagingProject/CMakePackagingProject)
set(prefix "cpp_find_or_build_dependency(\n")
set(prefix "${prefix}    NAME dummy2\n")
set(prefix "${prefix}    SOURCE_DIR ${root_dir}\n")
set(prefix "${prefix}    FIND_MODULE ${module}${suffix}")
_cpp_add_test(
TITLE "Basic find module usage"
"include(dependency/cpp_find_or_build_dependency)"
"cpp_find_or_build_dependency("
"   NAME dummy2"
"   SOURCE_DIR ${root_dir}"
"   FIND_MODULE ${module}"
")"
"_cpp_assert_target_property("
"   _cpp_dummy2_External"
"   INTERFACE_VERSION"
"   \"${prefix}\""
")"
)
