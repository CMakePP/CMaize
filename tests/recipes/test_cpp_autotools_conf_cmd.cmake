include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("autotools_conf_cmd")

set(comps "CXX=${CMAKE_CXX_COMPILER} CC=${CMAKE_C_COMPILER}")
set(flags " ")

set(src_dir ${test_prefix}/${test_number})
set(install_dir ${src_dir}/install)
set(corr "${src_dir}/configure --prefix=${install_dir} ${comps} ${flags}")

_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "include(recipes/cpp_autotools_conf_cmd)"
    "_cpp_autotools_conf_cmd("
    "   output"
    "   ${install_dir}"
    "   ${src_dir}"
    "   ${CMAKE_TOOLCHAIN_FILE}"
    "   \"\""
    ")"
    "_cpp_assert_equal(\"\${output}\" \"${corr}\")"
)

set(src_dir ${test_prefix}/${test_number})
set(install_dir ${src_dir}/install)
set(val1 "--with-val=val")
set(
    corr
    "${src_dir}/configure --prefix=${install_dir} ${val1} ${comps} ${flags}"
)
_cpp_add_test(
TITLE "Additional argument"
CONTENTS
    "include(recipes/cpp_autotools_conf_cmd)"
    "_cpp_autotools_conf_cmd("
    "   output"
    "   ${install_dir}"
    "   ${src_dir}"
    "   ${CMAKE_TOOLCHAIN_FILE}"
    "   \"with-val=val\""
    ")"
    "_cpp_assert_equal(\"\${output}\" \"${corr}\")"
)



set(valx "--with-x=x --with-y=y")
set(
    corr
    "${src_dir}/configure --prefix=${install_dir} ${valx} ${comps} ${flags}"
)
_cpp_add_test(
TITLE "Multiple additional arguments"
CONTENTS
    "include(recipes/cpp_autotools_conf_cmd)"
    "set(list \"with-x=x\" \"with-y=y\")"
    "_cpp_autotools_conf_cmd("
    "   output"
    "   ${install_dir}"
    "   ${src_dir}"
    "   ${CMAKE_TOOLCHAIN_FILE}"
    "   \"\${list}\""
    ")"
    "_cpp_assert_equal(\"\${output}\" \"${corr}\")"
)

set(flags "CXXFLAGS=-fPIC CFLAGS=-fPIC")
set(
    corr
    "${src_dir}/configure --prefix=${install_dir} ${comps} ${flags}"
)
_cpp_add_test(
TITLE "Honors CMAKE_POSITION_INDEPENDENT_CODE"
CONTENTS
    "include(recipes/cpp_autotools_conf_cmd)"
     "set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)"
     "_cpp_autotools_conf_cmd("
     "   output"
     "   ${install_dir}"
     "   ${src_dir}"
     "   ${CMAKE_TOOLCHAIN_FILE}"
     "   \"\""
     ")"
     "_cpp_assert_equal(\"\${output}\" \"${corr}\")"
)
