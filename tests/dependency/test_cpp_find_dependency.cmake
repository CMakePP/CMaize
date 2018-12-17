include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_add_dependency)
_cpp_setup_test_env("find_dependency")

set(suffix "\n    CPP_CACHE ${CPP_INSTALL_CACHE}\n)")
#Makes and installs a library to test_prefix/dummy/install
set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})
set(install_path ${src_dir}/install)

_cpp_add_test(
TITLE "Fails if NAME is not specified"
SHOULD_FAIL REASON "Required option _cfd_NAME is not set"
"include(dependency/cpp_find_dependency)"
"cpp_find_dependency()"
)

_cpp_add_test(
TITLE "Can't find project by default"
SHOULD_FAIL REASON "Could not find dummy."
"include(dependency/cpp_find_dependency)"
"cpp_find_dependency(NAME dummy)"
)

_cpp_add_test(
TITLE "Does not fail if can't find project and OPTIONAL set"
"include(dependency/cpp_find_dependency)"
"cpp_find_dependency(NAME dummy OPTIONAL)"
)

_cpp_add_test(
TITLE "Finds it with a good XXX_ROOT variable"
CONTENTS
    "include(dependency/cpp_find_dependency)"
    "set(dummy_ROOT ${install_path})"
    "cpp_find_dependency(NAME dummy)"
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
    "   \"cpp_find_dependency(\n    NAME dummy\n    VERSION 0.0.0${suffix}\""
    ")"
)

_cpp_add_test(
TITLE "Honors VERSION - not suitable version"
SHOULD_FAIL REASON "Variable DUMMY_ROOT set to"
"include(dependency/cpp_find_dependency)"
"set(DUMMY_ROOT ${install_path})"
"cpp_find_dependency(NAME dummy VERSION 1.0.0)"
)

set(prefix ${test_prefix}/${test_number})
_cpp_install_naive_cxx_package(install_dir ${prefix} NAME dummy2)
_cpp_naive_find_module(module ${prefix} NAME dummy2)

_cpp_add_test(
TITLE "Works with find module"
"include(dependency/cpp_find_dependency)"
"set(dummy2_ROOT ${install_dir})"
"cpp_find_dependency(NAME dummy2 FIND_MODULE ${module})"
)
