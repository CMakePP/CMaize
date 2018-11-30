include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("record_find")

#Code factorization for retrieving the property
set(
    get_prop
    "get_target_property(output _cpp_test_External INTERFACE_VERSION)"
)

#Code factorization for the correct answer
set(prefix "\"cpp_find_dependency(\n    NAME test\n")

################################################################################
#   Tests Start Here
################################################################################

_cpp_add_test(
TITLE "Fails if NAME is not set"
SHOULD_FAIL REASON "Required option _crf_NAME is not set"
CONTENTS
    "include(dependency/cpp_record_find)"
    "_cpp_record_find(cpp_find_dependency)"
)

_cpp_add_test(
TITLE "Basic call"
CONTENTS
    "include(dependency/cpp_record_find)"
    "_cpp_record_find(cpp_find_dependency NAME test)"
    "${get_prop}"

    "_cpp_assert_contains("
        "${prefix})\""
        "\"\${output}\""
    ")"
)

_cpp_add_test(
TITLE "Honors VERSION"
CONTENTS
    "include(dependency/cpp_record_find)"
    "_cpp_record_find(cpp_find_dependency NAME test VERSION 1.0.0)"
    "${get_prop}"
    "_cpp_assert_contains("
        "${prefix}    VERSION 1.0.0\n)\""
        "\"\${output}\""
    ")"
)

_cpp_add_test(
TITLE   "Honors COMPONENTS"
CONTENTS
    "include(dependency/cpp_record_find)"
    "_cpp_record_find(cpp_find_dependency NAME test COMPONENTS comp1 comp2)"
    "${get_prop}"
    "_cpp_assert_contains("
        "${prefix}    COMPONENTS comp1 comp2 \n)\""
        "\"\${output}\""
    ")"
)

_cpp_add_test(
TITLE   "Honors CMAKE_ARGS"
CONTENTS
    "include(dependency/cpp_record_find)"
    "_cpp_record_find("
    "   cpp_find_dependency"
    "   NAME test"
    "   CMAKE_ARGS var1=val1 var2=val2"
    ")"
    "${get_prop}"
    "_cpp_assert_contains("
        "${prefix}    CMAKE_ARGS var1=val1 var2=val2 \n)\""
        "\"\${output}\""
    ")"
)

set(prefix "cpp_find_dependency(\n    OPTIONAL\n    NAME test\n")
set(prefix "${prefix}    VERSION 1.0.0\n")
set(prefix "${prefix}    URL www.awebsite.com\n")
set(prefix "${prefix}    COMPONENTS comp1 comp2 \n")
set(prefix "${prefix}    CMAKE_ARGS var1=val1 var2=val2 \n)")
_cpp_add_test(
TITLE "The whole darn signature"
CONTENTS
    "include(dependency/cpp_record_find)"
    "_cpp_record_find("
    "   cpp_find_dependency"
    "   NAME test"
    "   OPTIONAL"
    "   VERSION 1.0.0"
    "   URL www.awebsite.com"
    "   COMPONENTS comp1 comp2"
    "   CMAKE_ARGS var1=val1 var2=val2"
    ")"
    "${get_prop}"
    "_cpp_assert_contains("
        "\"${prefix}\""
        "\"\${output}\""
    ")"
)
