include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_dependency")

_cpp_install_dummy_cxx_package(install ${test_prefix}/${test_number})

_cpp_add_test(
TITLE "Config: Can't find project by default"
SHOULD_FAIL REASON "Could not find dummy."
"include(dependency/cpp_find_dependency)"
"cpp_find_dependency(NAME dummy)"
)

_cpp_add_test(
TITLE "Config: Does not fail if can't find project and OPTIONAL set"
"include(dependency/cpp_find_dependency)"
"cpp_find_dependency(NAME dummy OPTIONAL)"
)

_cpp_add_test(
TITLE "Config: Finds it with a good XXX_ROOT variable"
"include(dependency/cpp_find_dependency)"
"set(dummy_ROOT ${install})"
"cpp_find_dependency(NAME dummy)"
)

_cpp_add_test(
TITLE "Config: Finds it with a good xxx_DIR variable"
"include(dependency/cpp_find_dependency)"
"set(dummy_DIR ${install}/share/cmake/dummy)"
"cpp_find_dependency(NAME dummy)"
)

_cpp_add_test(
TITLE "Config: Finds it with CMAKE_PREFIX_PATH"
"include(dependency/cpp_find_dependency)"
"list(APPEND CMAKE_PREFIX_PATH ${install})"
"cpp_find_dependency(NAME dummy)"
)

_cpp_add_test(
TITLE "Config: Finds it with PATHS"
"include(dependency/cpp_find_dependency)"
"cpp_find_dependency(NAME dummy PATHS ${install})"
)

set(prefix ${test_prefix}/${test_number})
_cpp_install_naive_cxx_package(install ${prefix} NAME dummy2)
_cpp_naive_find_module(module ${prefix} NAME dummy2)

_cpp_add_test(
TITLE "Module: Can't find project by default"
SHOULD_FAIL REASON "Could not find dummy2."
"include(dependency/cpp_find_dependency)"
"cpp_find_dependency(NAME dummy2)"
)

_cpp_add_test(
TITLE "Module: Finds it with a good XXX_ROOT variable"
"include(dependency/cpp_find_dependency)"
"set(dummy2_ROOT ${install})"
"cpp_find_dependency(NAME dummy2 FIND_MODULE ${module})"
)

_cpp_add_test(
TITLE "Module: Finds it with CMAKE_PREFIX_PATH"
"include(dependency/cpp_find_dependency)"
"list(APPEND CMAKE_PREFIX_PATH ${install})"
"cpp_find_dependency(NAME dummy2 FIND_MODULE ${module})"
)

_cpp_add_test(
TITLE "Module: Finds it with PATHS"
"include(dependency/cpp_find_dependency)"
"cpp_find_dependency(NAME dummy2 FIND_MODULE ${module} PATHS ${install})"
)
