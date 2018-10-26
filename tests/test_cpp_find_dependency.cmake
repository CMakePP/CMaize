include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers.cmake)
include(cpp_dependency)
include(cpp_assert)
_cpp_setup_build_env("find_dependency")

#Makes and installs a library to test_prefix/dummy/install
_cpp_install_dummy_cxx_package(${test_prefix}/dummy)
set(install_path ${test_prefix}/dummy/install)

#This is a common prefix for many of the tests
set(prefix "cpp_find_dependency(NAME dummy")

_cpp_add_test(
TITLE "Fails if NAME is not specified"
SHOULD_FAIL REASON "_cfd_NAME is set to false value:"
CONTENTS
    "cpp_find_dependency()"
)

_cpp_add_test(
TITLE "Can't find project by default"
CONTENTS
    "${prefix} RESULT output)"
    "_cpp_assert_false(output)"
)

_cpp_add_test(
TITLE "Fails if can't find project and REQUIRED set"
SHOULD_FAIL "No \"Finddummy.cmake\" found in CMAKE_MODULE_PATH"
CONTENTS
    "${prefix} REQUIRED)"
)

_cpp_add_test(
TITLE "Fails if bad XXX_ROOT is provided"
SHOULD_FAIL "No \"Finddummy.cmake\" found in CMAKE_MODULE_PATH"
CONTENTS
    "set(dummy_ROOT ${test_prefix}/a/bad/path)"
    "${prefix})"
)

_cpp_add_test(
TITLE "Finds it with a good XXX_ROOT variable"
CONTENTS
    "set(dummy_ROOT ${install_path})"
    "${prefix})"
)

_cpp_add_test(
TITLE "Finds it if PATHS are provided"
CONTENTS
    "${prefix} REQUIRED PATHS ${install_path})"
)

_cpp_add_test(
TITLE "Honors VERSION - compatible version"
CONTENTS
    "${prefix} VERSION 0.0.0 REQUIRED PATHS ${install_path})"
)

_cpp_add_test(
TITLE "Honors VERSION - not suitable version"
SHOULD_FAIL REASON "No \"Finddummy.cmake\" found in CMAKE_MODULE_PATH"
CONTENTS
    "${prefix} VERSION 1.0.0 REQUIRED PATHS ${install_path})"
)

#_cpp_add_test(
#TITLE "Honors COMPONENTS"
#CONTENTS
#    "${prefix} COMPONENTS dummy::dummy REQUIRED PATHS ${install_path})"
#)
#
#_cpp_add_test(
#TITLE "Fails if not all COMPONENTS are found"
#CONTENTS
#    "${prefix} COMPONENTS dummy fake_comp REQUIRED PATHS ${install_path})"
#)
