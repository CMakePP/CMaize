include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("build_recipe_dispatch")

set(header "function(_cpp_build_recipe _cbr_install _cbr_src _cbr_tc)")
set(footer "endfunction()")

set(
    body
    "_cpp_configure_dispatch(\\\${_cbr_install} \\\${_cbr_src} \\\${_cbr_tc})"
)
_cpp_add_test(
TITLE "Autobuild project: contents"
CONTENTS
    "include(recipes/cpp_build_recipe_dispatch)"
    "_cpp_build_recipe_dispatch(output)"
    "_cpp_assert_contains(\"${header}\" \"\${output}\")"
    "_cpp_assert_contains(\"${body}\" \"\${output}\")"
    "_cpp_assert_contains(\"${footer}\" \"\${output}\")"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(${src_dir})
set(recipe ${src_dir}/build-dummy.cmake)
_cpp_add_test(
TITLE "Autobuild project: works"
CONTENTS
    "include(recipes/cpp_build_recipe_dispatch)"
    "_cpp_build_recipe_dispatch(output)"
    "file(WRITE ${recipe} \"\${output}\")"
    "include(${recipe})"
    "_cpp_build_recipe("
    "   ${src_dir}/install"
    "   ${src_dir}/dummy"
    "   ${CMAKE_TOOLCHAIN_FILE}"
    ")"
    "_cpp_assert_exists(${src_dir}/install/include)"
)

file(WRITE ${test_prefix}/Builddummy.cmake
"cpp_add_library(
  dummy
  SOURCES  a.cpp
  INCLUDES a.hpp
)
cpp_install(TARGETS dummy)"
)

set(body "_cpp_run_sub_build(")
_cpp_add_test(
TITLE "Build module: contents"
CONTENTS
    "include(recipes/cpp_build_recipe_dispatch)"
    "_cpp_build_recipe_dispatch("
    "   output BUILD_MODULE ${test_prefix}/Builddummy.cmake"
    ")"
    "_cpp_assert_contains(\"${header}\" \"\${output}\")"
    "_cpp_assert_contains(\"${body}\" \"\${output}\")"
    "_cpp_assert_contains(\"${footer}\" \"\${output}\")"
)

set(src_dir ${test_prefix}/${test_number})
set(recipe ${src_dir}/build-dummy.cmake)
_cpp_dummy_cxx_library(${src_dir}/dummy)
_cpp_add_test(
TITLE "Build module: works"
CONTENTS
    "include(recipes/cpp_build_recipe_dispatch)"
    "_cpp_build_recipe_dispatch("
    "   output"
    "   BUILD_MODULE ${test_prefix}/Builddummy.cmake"
    ")"
    "file(WRITE ${recipe} \"\${output}\")"
    "include(${recipe})"
        "_cpp_build_recipe("
        "   ${src_dir}/install"
        "   ${src_dir}/dummy"
        "   ${CMAKE_TOOLCHAIN_FILE}"
        ")"
        "_cpp_assert_exists(${src_dir}/install/include)"
)
