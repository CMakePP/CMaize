include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_or_build_dependency")

_cpp_add_test(
TITLE "Crashes if NAME not set"
SHOULD_FAIL REASON "_cfobd_NAME is set to false value:"
CONTENTS "cpp_find_or_build_dependency()"
)

_cpp_install_dummy_cxx_package(${test_prefix}/${test_number})

_cpp_add_test(
TITLE "Finds existing dependency"
CONTENTS
    "set(dummy_ROOT ${test_prefix}/${test_number}/install)"
    "cpp_find_or_build_dependency(NAME dummy)"
)

_cpp_dummy_cxx_package(${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Basic local usage"
CONTENTS
    "cpp_find_or_build_dependency(
    "   NAME dummy
    "   SOURCE_DIR ${test_prefix}/${test_number}/dummy"
    ")"
)

_cpp_dummy_cxx_package(${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Updates interface target correctly"
CONTENTS
    "cpp_find_or_build_dependency(
    "   NAME dummy
    "   SOURCE_DIR ${test_prefix}/${test_number}/dummy"
    ")"
    "get_target_property(msg _cpp_dummy_interface INTERFACE_VERSION)"
    "_cpp_assert_contains(\"PATHS ${test_prefix}/cpp_cache\" \"\${msg}\")"
)

_cpp_add_test(
TITLE "Basic URL usage"
CONTENTS
    "cpp_find_or_build_dependency(
    "   NAME cpp
    "   URL github.com/CMakePackagingProject/CMakePackagingProject"
    ")"
)
