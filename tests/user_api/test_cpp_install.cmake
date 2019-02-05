include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("install")

set(root ${test_prefix}/${test_number})
_cpp_dummy_cxx_library(${root})
set(src ${root}/${dummy})

_cpp_add_test(
TITLE "Basic library"
"include(user_api/cpp_add_library)"
"set(CMAKE_INSTALL_PREFIX ${root}/install)"
"cpp_add_library(dummy SOURCES ${src}/a.cpp INCLUDES ${src}/a.hpp)"
"_cpp_assert_does_not_exist(\${CMAKE_INSTALL_PREFIX})"
"cpp_install(TARGETS dummy)"
)
#Outside b/c subbuild needs to complete for it to install
_cpp_assert_exists(${root}/install)
