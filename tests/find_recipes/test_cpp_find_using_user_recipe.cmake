include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_using_user_recipe")

set(contents
"list(APPEND CMAKE_MODULE_PATH /a/path1)
list(APPEND CMAKE_PREFIX_PATH /a/path2)
find_package(
    test
    1.0
    COMPONENTS comp1 comp2
    MODULE
    QUIET
)
")

_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "include(cpp_find_recipes)"
    "_cpp_find_using_user_recipe("
    "   test test 1.0 \"COMPONENTS comp1 comp2\" /a/path1 /a/path2"
    ")"
    "_cpp_assert_contains(\"${contents}\" \"\${test}\")"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_naive_install_cxx_package(${src_dir})
#Write a typical Finddummy.cmake file
file(
    WRITE "${src_dir}/Finddummy.cmake"
"
find_path(DUMMY_INCLUDE_DIR a.hpp)
find_library(DUMMY_LIBRARY dummy)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    DUMMY DEFAULT_MSG
    DUMMY_LIBRARY
    DUMMY_INCLUDE_DIR
)
set(DUMMY_INCLUDE_DIRS \${DUMMY_INCLUDE_DIR})
set(DUMMY_LIBRARIES \${DUMMY_LIBRARY})
"
)

set(install_dir ${src_dir}/dummy/install)
_cpp_add_test(
TITLE "Can use a CMake module file and honors UPPERCASE versions of variables"
CONTENTS
    "include(cpp_find_recipes)"
    "_cpp_find_using_user_recipe("
    "   test dummy \"\" \"\" ${src_dir} ${install_dir}"
    ")"
    "file(WRITE ${src_dir}/find-dummy.cmake \"\${test}\")"
    "include(${src_dir}/find-dummy.cmake)"
    "_cpp_assert_true(DUMMY_FOUND)"
    "_cpp_assert_target_property("
    "   dummy INTERFACE_INCLUDE_DIRECTORIES ${install_dir}/include"
    ")"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_naive_install_cxx_package(${src_dir})
#Write a typical Finddummy.cmake file
file(
WRITE "${src_dir}/Finddummy.cmake"
"
find_path(DUMMY_INCLUDE_DIR a.hpp)
find_library(DUMMY_LIBRARY dummy)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    DUMMY DEFAULT_MSG
    DUMMY_LIBRARY
    DUMMY_INCLUDE_DIR
)
set(dummy_INCLUDE_DIRS \${DUMMY_INCLUDE_DIR})
set(dummy_LIBRARIES \${DUMMY_LIBRARY})
"
)

set(install_dir ${src_dir}/dummy/install)
_cpp_add_test(
TITLE "Can use a CMake module file and honors input case version of variables"
CONTENTS
    "include(cpp_find_recipes)"
    "_cpp_find_using_user_recipe("
    "   test dummy \"\" \"\" ${src_dir} ${install_dir}"
    ")"
    "file(WRITE ${src_dir}/find-dummy.cmake \"\${test}\")"
    "include(${src_dir}/find-dummy.cmake)"
    "_cpp_assert_true(DUMMY_FOUND)"
    "_cpp_assert_target_property("
    "   dummy INTERFACE_INCLUDE_DIRECTORIES ${install_dir}/include"
    ")"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_naive_install_cxx_package(${src_dir})
#Write a typical Finddummy.cmake file
file(
    WRITE "${src_dir}/Finddummy.cmake"
"
find_path(DUMMY_INCLUDE_DIR a.hpp)
find_library(DUMMY_LIBRARY dummy)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    DUMMY DEFAULT_MSG
    DUMMY_LIBRARY
    DUMMY_INCLUDE_DIR
)
add_library(test_dummy INTERFACE)
target_include_directories(test_dummy INTERFACE \${DUMMY_INCLUDE_DIR})
target_link_libraries(test_dummy INTERFACE \${DUMMY_LIBRARY})
"
)
set(install_dir ${src_dir}/dummy/install)
_cpp_add_test(
TITLE "Honors targets created by module"
CONTENTS
    "include(cpp_find_recipes)"
    "_cpp_find_using_user_recipe("
    "   test dummy \"\" \"\" ${src_dir} ${install_dir}"
    ")"
    "file(WRITE ${src_dir}/find-dummy.cmake \"\${test}\")"
    "include(${src_dir}/find-dummy.cmake)"
    "_cpp_assert_true(DUMMY_FOUND)"
    "_cpp_assert_target_property("
    "   test_dummy INTERFACE_INCLUDE_DIRECTORIES ${install_dir}/include"
    ")"
)
