include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)
include(cpp_dependency)
include(cpp_assert)

_cpp_setup_build_env("cpp_dependency")
file(SHA1 ${CMAKE_TOOLCHAIN_FILE} toolchain_hash)

################################################################################
# Test _cpp_depend_install_path
################################################################################

_cpp_depend_install_path(test1_return dummy)
_cpp_assert_equal(
    "${test_prefix}/cpp_cache/dummy/${toolchain_hash}"
    "${test1_return}"
)

################################################################################
# Test _cpp_build_dependency
################################################################################

set(test_root ${test_prefix}/build_depend)
set(test1_root ${test_root}/test1)
_cpp_dummy_cxx_package(${test1_root})
_cpp_make_build_recipe(${test1_root} dummy)
_cpp_write_top_list(
        PATH ${test1_root}
        NAME build_depend_test
        CONTENTS
        "include(cpp_dependency)
        _cpp_build_dependency(dummy)"
)
_cpp_run_sub_build(
        ${test1_root}
        NO_INSTALL
        OUTPUT test1_output
)

set(cache_root ${test_prefix}/cpp_cache/dummy/${toolchain_hash})
_cpp_assert_exists(${cache_root}/include/dummy/a.hpp)
foreach(cmake_file dummy-config dummy-config-version dummy-targets)
        _cpp_assert_exists(${cache_root}/share/cmake/dummy/${cmake_file}.cmake)
endforeach()

#Fails when recipe is not found
set(test2_root ${test_root}/test2)
_cpp_write_top_list(
        PATH ${test2_root}
        NAME build_depend_test
        CONTENTS
        "include(cpp_dependency)
        _cpp_build_dependency(dummy)"
)
_cpp_run_cmake_command(
    COMMAND
    "_cpp_run_sub_build(
        ${test2_root}
        NO_INSTALL
        OUTPUT test2_output
    )
    "
    INCLUDES cpp_cmake_helpers
    OUTPUT test2_output
    RESULT test2_result
    CMAKE_ARGS CPP_DEBUG_MODE=ON
)
_cpp_assert_true(test2_result)
_cpp_assert_contains("_cbd_dummy_recipe-NOTFOUND" "${test2_output}")

################################################################################
# cpp_find_dependency
################################################################################

#Build and install dummy to a specific spot
set(test_root ${test_prefix}/find_depend)
set(test1_root ${test_root}/test1)
_cpp_install_dummy_cxx_package(${test1_root})

#Test we can find the user-specified version
_cpp_write_top_list(
        PATH ${test1_root}
        NAME find_dummy
        CONTENTS "include(cpp_dependency)
        set(CPP_dummy_ROOT ${test1_root}/install)
        cpp_find_dependency(test1_found dummy)
        "
)

_cpp_run_sub_build(
        ${test1_root}
        NO_INSTALL
        OUTPUT test1_output
        CMAKE_ARGS CPP_DEBUG_MODE=ON
)
set(test1_path ${test1_root}/install/share/cmake/dummy/dummy-config.cmake)
_cpp_assert_contains("Found config file: ${test1_path}" "${test1_output}")

#Test we can find cached version from the building test
set(test2_root ${test_root}/test2)
_cpp_write_top_list(
        PATH ${test2_root}
        NAME find_dummy
        CONTENTS "include(cpp_dependency)
        cpp_find_dependency(test2_found dummy)
        "
)

_cpp_run_sub_build(
        ${test2_root}
        NO_INSTALL
        OUTPUT test2_output
        CMAKE_ARGS CPP_DEBUG_MODE=ON
)

set(
    test2_path
    ${test_prefix}/cpp_cache/dummy/${toolchain_hash}/share/cmake/dummy
)
_cpp_assert_contains(
        "Found config file: ${test2_path}/dummy-config.cmake"
        "${test2_output}"
)

#Test library DNE
set(test3_root ${test_root}/test3)
_cpp_write_top_list(
        PATH ${test3_root}
        NAME find_dne_depend
        CONTENTS "include(cpp_dependency)
        cpp_find_dependency(test3_found dummy2)
        message(\"Dummy2 status: \${test3_found}\")
        "
)

_cpp_run_sub_build(
    ${test3_root}
    NO_INSTALL
    OUTPUT test3_output
)

_cpp_assert_contains("Dummy2 status: FALSE" "${test3_output}")

################################################################################
# Test cpp_find_or_build_dependency
################################################################################
set(test_root ${test_prefix}/find_build_depend)
set(test1_root ${test_root}/test1)
_cpp_dummy_cxx_package(${test1_root} NAME dummy2)
_cpp_make_build_recipe(${test1_root} dummy2)

_cpp_write_top_list(
    PATH ${test1_root}
    NAME find_or_build_dummy
    CONTENTS "include(cpp_dependency)
    cpp_find_or_build_dependency(dummy2)"
)

_cpp_run_sub_build(
    ${test1_root}
    NO_INSTALL
    OUTPUT test1_output
)
message("${test1_output}")
