include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("find_from_module")

set(src_dir ${test_prefix}/${test_number})
_cpp_naive_install_cxx_package(${src_dir})

#Write a typical Finddummy.cmake file
file(
    WRITE "${test_prefix}/Finddummy.cmake"
"find_path(DUMMY_INCLUDE_DIR a.hpp)
find_library(DUMMY_LIBRARY dummy)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    dummy DEFAULT_MSG
    DUMMY_LIBRARY
    DUMMY_INCLUDE_DIR
)
set(DUMMY_INCLUDE_DIRS \${DUMMY_INCLUDE_DIR})
set(DUMMY_LIBRARIES \${DUMMY_LIBRARY})
"
)
#I think CMake is finding it in the package registry, but I'm having problems
#stopping that behavior

#_cpp_add_test(
#TITLE "Does not find dummy w/o path"
#CONTENTS
#    "include(recipes/cpp_find_from_module)"
#    "list(APPEND CMAKE_MODULE_PATH ${test_prefix})"
#    "_cpp_find_from_module(dummy \"\" \"\" \"\")"
#    "message(\"\${DUMMY_INCLUDE_DIR}\")"
#    "_cpp_assert_false(dummy_FOUND)"
#)


_cpp_add_test(
TITLE "Finds dummy with path"
CONTENTS
    "include(recipes/cpp_find_from_module)"
    "list(APPEND CMAKE_MODULE_PATH ${test_prefix})"
    "_cpp_find_from_module(dummy \"\" \"\" ${src_dir}/install)"
    "_cpp_assert_true(dummy_FOUND)"
)

_cpp_add_test(
TITLE "Fails if module file is not in CMAKE_MODULE_PATH"
SHOULD_FAIL REASON "Finddummy.cmake was not found in"
CONTENTS
    "include(recipes/cpp_find_from_module)"
    "_cpp_find_from_module(dummy \"\" \"\" \"\")"
)
