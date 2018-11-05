include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("unpack_list")

_cpp_add_test(
TITLE "Empty list unpacks to empty"
CONTENTS
    "set(empty \"\")"
    "_cpp_unpack_list(unpacked \"\${empty}\")"
    "_cpp_assert_equal(\"\${unpacked}\" \"\")"
)

_cpp_add_test(
TITLE "Single element list unpacks"
CONTENTS
    "set(one_item one)"
    "_cpp_pack_list(packed \"\${one_item}\")"
    "_cpp_unpack_list(unpacked \"\${packed}\")"
    "_cpp_assert_equal(\"\${unpacked}\" \"one\")"
)

_cpp_add_test(
TITLE "Two element list unpacks"
CONTENTS
    "set(two_item one two)"
    "_cpp_pack_list(packed \"\${two_item}\")"
    "_cpp_unpack_list(unpacked \"\${packed}\")"
    "_cpp_assert_equal(\"\${unpacked}\" \"\${two_item}\")"
)
