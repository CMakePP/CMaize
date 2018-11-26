include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_dependency")

#Makes and installs a library to test_prefix/dummy/install
_cpp_install_dummy_cxx_package(${test_prefix}/dummy)
set(install_path ${test_prefix}/dummy/install)

_cpp_add_test(
TITLE "Fails if NAME is not specified"
SHOULD_FAIL REASON "Required option _cfd_NAME is not set"
CONTENTS "cpp_find_dependency()"
)

_cpp_add_test(
TITLE "Can't find project by default"
SHOULD_FAIL REASON "Could not locate dummy"
CONTENTS "cpp_find_dependency(NAME dummy)"
)

_cpp_add_test(
TITLE "Does not fails if can't find project and OPTIONAL set"
CONTENTS
    "cpp_find_dependency(NAME dummy OPTIONAL)"
    "_cpp_assert_target_property("
    "   _cpp_dummy_External"
    "   INTERFACE_VERSION"
    "   \"cpp_find_dependency(\n    OPTIONAL\n    NAME dummy\n)\""
    ")"
)

_cpp_add_test(
TITLE "Finds it with a good XXX_ROOT variable"
CONTENTS
    "set(dummy_ROOT ${install_path})"
    "cpp_find_dependency(NAME dummy)"
    "_cpp_assert_target_property("
    "   _cpp_dummy_External"
    "   INTERFACE_VERSION"
    "   \"cpp_find_dependency(\n    NAME dummy\n)\""
    ")"

)

_cpp_add_test(
TITLE "Finds it if CMAKE_PREFIX_PATH is set"
CONTENTS
    "set(CMAKE_PREFIX_PATH ${install_path})"
    "cpp_find_dependency(NAME dummy)"
)

_cpp_add_test(
TITLE "Honors VERSION - compatible version"
CONTENTS
    "set(DUMMY_ROOT ${install_path})"
    "cpp_find_dependency(NAME dummy VERSION 0.0.0)"
    "_cpp_assert_target_property("
    "   _cpp_dummy_External"
    "   INTERFACE_VERSION"
    "   \"cpp_find_dependency(\n    NAME dummy\n    VERSION 0.0.0\n)\""
    ")"
)

_cpp_add_test(
TITLE "Honors VERSION - not suitable version"
SHOULD_FAIL REASON "DUMMY_ROOT set, but dummy not found there"
CONTENTS
    "set(DUMMY_ROOT ${install_path})"
    "cpp_find_dependency(NAME dummy VERSION 1.0.0)"
)
