include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("target_has_property")

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_library(${src_dir})

_cpp_add_test(
TITLE "Normal: returns false if property is non-existant."
"include(target/target_has_property)"
"add_library(dummy ${src_dir}/a.cpp)"
"_cpp_target_has_property(result dummy NOT_A_PROPERTY)"
"_cpp_assert_false(result)"
)

_cpp_add_test(
TITLE "Normal: returns false if property exists, but is not set."
"include(target/target_has_property)"
"add_library(dummy ${src_dir}/a.cpp)"
 "_cpp_target_has_property(result dummy INTERFACE_INCLUDE_DIRECTORIES)"
"_cpp_assert_false(result)"
)

_cpp_add_test(
TITLE "Normal: returns true if property exists and is set."
"include(target/target_has_property)"
"add_library(dummy ${src_dir}/a.cpp)"
"target_include_directories(dummy PUBLIC some/path)"
"_cpp_target_has_property(result dummy INCLUDE_DIRECTORIES)"
"_cpp_assert_true(result)"
)

_cpp_add_test(
TITLE "Interface: returns false if property is non-existant."
"include(target/target_has_property)"
"add_library(dummy INTERFACE)"
"_cpp_target_has_property(result dummy NOT_A_PROPERTY)"
"_cpp_assert_false(result)"
)

_cpp_add_test(
TITLE "Interface: returns false if property is blacklisted."
"include(target/target_has_property)"
"add_library(dummy INTERFACE)"
"_cpp_target_has_property(result dummy LINK_LIBRARIES)"
"_cpp_assert_false(result)"
)

_cpp_add_test(
TITLE "Interface: returns false if whitelisted property exists, but is not set."
"include(target/target_has_property)"
 "add_library(dummy INTERFACE)"
 "_cpp_target_has_property(result dummy INTERFACE_INCLUDE_DIRECTORIES)"
"_cpp_assert_false(result)"
)

_cpp_add_test(
TITLE "Interface: returns true if property exists and is set."
"include(target/target_has_property)"
"add_library(dummy INTERFACE)"
"target_include_directories(dummy INTERFACE some/path)"
"_cpp_target_has_property(result dummy INTERFACE_INCLUDE_DIRECTORIES)"
"_cpp_assert_true(result)"
)
