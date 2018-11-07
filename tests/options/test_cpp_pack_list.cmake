include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("pack_list")

_cpp_add_test(
TITLE "Empty list is empty"
CONTENTS
    "set(empty \"\")"
    "_cpp_pack_list(output \"\${empty}\")"
    "_cpp_assert_equal(\"\${output}\" \"\")"
)

_cpp_add_test(
TITLE "Single element list comes back unchanged"
CONTENTS
    "set(one_item one)"
    "_cpp_pack_list(output \"\${one_item}\")"
    "_cpp_assert_equal(\"\${output}\" \"one\")"
)

_cpp_add_test(
TITLE "Two elements has item separator"
CONTENTS
    "set(two_item one two)"
    "_cpp_pack_list(output \"\${two_item}\")"
    "_cpp_assert_equal("
    "    \"\${output}\""
    "    \"one_cpp_0_cpp_two\""
    ")"
)

_cpp_add_test(
TITLE "Double nesting errs"
SHOULD_FAIL REASON "List is already packed."
CONTENTS
    "set(two_item one two)"
    "_cpp_pack_list(output \"\${two_item}\")"
    "set(two_item2 \${output} \${output})"
    "_cpp_pack_list(output2 \"\${two_item2}\")"
)
