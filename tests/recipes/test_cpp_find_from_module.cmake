include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_from_module")

set(src_dir ${test_prefix}/${test_number})
_cpp_install_naive_cxx_package(install_dir ${src_dir})
_cpp_naive_find_module(module ${test_prefix})

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
    "_cpp_find_from_module(found dummy \"\" \"\" ${install_dir} ${module})"
    "_cpp_assert_true(found)"
)

_cpp_add_test(
TITLE "Fails if module file does not exist"
SHOULD_FAIL REASON "No such file or directory: not/a/directory"
CONTENTS
    "include(recipes/cpp_find_from_module)"
    "_cpp_find_from_module(found dummy \"\" \"\" \"\" not/a/directory)"
    "_cpp_assert_false(found)"
)
