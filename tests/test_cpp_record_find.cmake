include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers.cmake)
include(cpp_dependency)
include(cpp_assert)
_cpp_setup_build_env("record_find")

#Code factorization for retrieving the property
set(
    get_prop
    "get_target_property(output _cpp_test_interface INTERFACE_VERSION)"
)

#Code factorization for the correct answer
set(prefix "\"cpp_find_dependency(\n    NAME test\n")

################################################################################
#   Tests Start Here
################################################################################

_cpp_add_test(
TITLE "Fails if NAME is not set"
SHOULD_FAIL REASON "_crf_NAME is set to false value:"
CONTENTS "_cpp_record_find()"
)

_cpp_add_test(
TITLE "Basic call"
CONTENTS
    "_cpp_record_find(NAME test)"
    "${get_prop}"
    "_cpp_assert_contains("
        "${prefix})\""
        "\"\${output}\""
    ")"
)

_cpp_add_test(
TITLE "Honors VERSION"
CONTENTS
    "_cpp_record_find(NAME test VERSION 1.0.0)"
    "${get_prop}"
    "_cpp_assert_contains("
        "${prefix}    VERSION 1.0.0\n)\""
        "\"\${output}\""
    ")"
)

_cpp_add_test(
TITLE   "Honors COMPONENTS"
CONTENTS
    "_cpp_record_find(NAME test COMPONENTS comp1 comp2)"
    "${get_prop}"
    "_cpp_assert_contains("
        "${prefix}    COMPONENTS comp1 comp2 \n)\""
        "\"\${output}\""
    ")"
)

_cpp_add_test(
TITLE   "Honors CMAKE_ARGS"
CONTENTS
    "_cpp_record_find(NAME test CMAKE_ARGS var1=val1 var2=val2)"
    "${get_prop}"
    "_cpp_assert_contains("
        "${prefix}    CMAKE_ARGS var1=val1 var2=val2 \n)\""
        "\"\${output}\""
    ")"
)

set(prefix2 "${prefix}    VERSION 1.0.0\n    COMPONENTS comp1 comp2 \n")
_cpp_add_test(
TITLE "The whole darn signature"
CONTENTS
    "_cpp_record_find(NAME test VERSION 1.0.0 COMPONENTS comp1 comp2"
    "                 CMAKE_ARGS var1=val1 var2=val2)"
    "${get_prop}"
    "_cpp_assert_contains("
        "${prefix2}    CMAKE_ARGS var1=val1 var2=val2 \n)\""
        "\"\${output}\""
    ")"
)
