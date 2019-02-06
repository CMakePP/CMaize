include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("add_library")

set(root ${test_prefix}/${test_number})
_cpp_dummy_cxx_library(${root})
set(src ${root}/${dummy})

_cpp_add_test(
TITLE "Basic library"
"include(user_api/cpp_add_library)"
"cpp_add_library(dummy SOURCES ${src}/a.cpp INCLUDES ${src}/a.hpp)"
"get_target_property(test dummy INCLUDE_DIRECTORIES)"
"set(corr  \"\$<BUILD_INTERFACE:${root}>\" \"\$<INSTALL_INTERFACE:include>\")"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
"get_target_property(test dummy SOURCES)"
"_cpp_assert_equal(\"\${test}\" \"${src}/a.cpp\")"
"get_target_property(test dummy PUBLIC_HEADER)"
"_cpp_assert_equal(\"\${test}\" \"${src}/a.hpp\")"
"get_target_property(test dummy COMPILE_FEATURES)"
"_cpp_assert_equal(\"\${test}\" \"cxx_std_17\")"
)

set(root ${test_prefix}/${test_number})
_cpp_dummy_cxx_library(${root})
set(src ${root}/${dummy})

_cpp_add_test(
TITLE "Header-only"
"include(user_api/cpp_add_library)"
"cpp_add_library(dummy INCLUDES ${src}/a.hpp)"
"get_target_property(test dummy INTERFACE_INCLUDE_DIRECTORIES)"
"set(corr  \"\$<BUILD_INTERFACE:${root}>\" \"\$<INSTALL_INTERFACE:include>\")"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
"get_target_property(test dummy INTERFACE_COMPILE_FEATURES)"
"_cpp_assert_equal(\"\${test}\" \"cxx_std_17\")"
)

set(root ${test_prefix}/${test_number})
_cpp_dummy_cxx_library(${root})
set(src ${root}/${dummy})

_cpp_add_test(
TITLE "Library with dependency"
"include(user_api/cpp_add_library)"
"add_library(depend1 INTERFACE)"
"target_include_directories(depend1 INTERFACE /a/path)"
"cpp_add_library("
"   dummy SOURCES ${src}/a.cpp INCLUDES ${src}/a.hpp DEPENDS depend1"
")"
"get_target_property(test dummy INCLUDE_DIRECTORIES)"
"set(corr  \"\$<BUILD_INTERFACE:${root}>\" \"\$<INSTALL_INTERFACE:include>\")"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
"get_target_property(test dummy SOURCES)"
"_cpp_assert_equal(\"\${test}\" \"${src}/a.cpp\")"
"get_target_property(test dummy PUBLIC_HEADER)"
"_cpp_assert_equal(\"\${test}\" \"${src}/a.hpp\")"
"get_target_property(test dummy COMPILE_FEATURES)"
"_cpp_assert_equal(\"\${test}\" \"cxx_std_17\")"
"get_target_property(test dummy LINK_LIBRARIES)"
"_cpp_assert_equal(\"\${test}\" \"depend1\")"
)

set(root ${test_prefix}/${test_number})
_cpp_dummy_cxx_library(${root})
set(src ${root}/${dummy})

_cpp_add_test(
TITLE "Different C++ support"
"include(user_api/cpp_add_library)"
"cpp_add_library("
"   dummy SOURCES ${src}/a.cpp INCLUDES ${src}/a.hpp CXX_STANDARD 14"
")"
"get_target_property(test dummy INCLUDE_DIRECTORIES)"
"set(corr  \"\$<BUILD_INTERFACE:${root}>\" \"\$<INSTALL_INTERFACE:include>\")"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
"get_target_property(test dummy SOURCES)"
"_cpp_assert_equal(\"\${test}\" \"${src}/a.cpp\")"
"get_target_property(test dummy PUBLIC_HEADER)"
"_cpp_assert_equal(\"\${test}\" \"${src}/a.hpp\")"
"get_target_property(test dummy COMPILE_FEATURES)"
"_cpp_assert_equal(\"\${test}\" \"cxx_std_14\")"
)

_cpp_add_test(
TITLE "Static library without sources is an error"
SHOULD_FAIL REASON "Static libraries need source files..."
"include(user_api/cpp_add_library)"
"cpp_add_library(dummy STATIC INCLUDES ${root}/a.hpp)"
)

set(root ${test_prefix}/${test_number})
_cpp_dummy_cxx_library(${root})
set(src ${root}/${dummy})

_cpp_add_test(
TITLE "Can change the include directory"
"include(user_api/cpp_add_library)"
"cpp_add_library("
"   dummy SOURCES ${src}/a.cpp INCLUDES ${src}/a.hpp INCLUDE_DIR /a/path"
")"
"get_target_property(test dummy INCLUDE_DIRECTORIES)"
"set(corr  \"\$<BUILD_INTERFACE:/a/path>\" \"\$<INSTALL_INTERFACE:include>\")"
"_cpp_assert_equal(\"\${test}\" \"\${corr}\")"
"get_target_property(test dummy SOURCES)"
"_cpp_assert_equal(\"\${test}\" \"${src}/a.cpp\")"
"get_target_property(test dummy PUBLIC_HEADER)"
"_cpp_assert_equal(\"\${test}\" \"${src}/a.hpp\")"
"get_target_property(test dummy COMPILE_FEATURES)"
"_cpp_assert_equal(\"\${test}\" \"cxx_std_17\")"
)
