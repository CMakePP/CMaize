include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_add_dependency)

_cpp_setup_build_env("find_dependency")

#Makes and installs a library to test_prefix/dummy/install
set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})
_cpp_cache_add_dependency(
    ${CPP_INSTALL_CACHE} dummy SOURCE_DIR ${src_dir}/dummy
)
set(install_path ${src_dir}/install)

_cpp_add_test(
TITLE "Fails if NAME is not specified"
SHOULD_FAIL REASON "Required option _cfd_NAME is not set"
CONTENTS
    "include(dependency/cpp_find_dependency)"
    "cpp_find_dependency()"
)

_cpp_add_test(
TITLE "Can't find project by default"
SHOULD_FAIL REASON "Could not locate dummy"
CONTENTS
    "include(dependency/cpp_find_dependency)"
    "cpp_find_dependency(NAME dummy)"
)

_cpp_add_test(
TITLE "Does not fails if can't find project and OPTIONAL set"
CONTENTS
    "include(dependency/cpp_find_dependency)"
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
    "include(dependency/cpp_find_dependency)"
    "set(dummy_ROOT ${install_path})"
    "cpp_find_dependency(NAME dummy)"
    "_cpp_assert_target_property("
    "   _cpp_dummy_External"
    "   INTERFACE_VERSION"
    "   \"cpp_find_dependency(\n    NAME dummy\n)\""
    ")"

)

_cpp_add_test(
TITLE "Honors VERSION - compatible version"
CONTENTS
    "include(dependency/cpp_find_dependency)"
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
    "include(dependency/cpp_find_dependency)"
    "set(DUMMY_ROOT ${install_path})"
    "cpp_find_dependency(NAME dummy VERSION 1.0.0)"
)
