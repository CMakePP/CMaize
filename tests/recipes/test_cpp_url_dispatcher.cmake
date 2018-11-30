include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("url_dispatcher")


#No idea why, but it won't match when I try to put them together
set(pieces
    "include(recipes/cpp_get_from_gh)"
    "_cpp_get_from_gh("
    "    \\\${_cgr_tar}"
    "    \\\"\\\${_cgr_version}\\\""
    "    github.com/org/repo"
    ")"
)

_cpp_add_test(
TITLE "Basic GitHub usage"
CONTENTS
    "include(recipes/cpp_url_dispatcher)"
    "_cpp_url_dispatcher(output github.com/org/repo)"
    "foreach(_piece ${pieces})"
    "    _cpp_assert_contains(\"\${_piece}\" \"\${output}\")"
    "endforeach()"
)


set(dd_line "_cpp_download_tarball(\\\${_cgr_tar} www.website.com)")
_cpp_add_test(
TITLE "Direct download link"
CONTENTS
    "include(recipes/cpp_url_dispatcher)"
    "_cpp_url_dispatcher(output \"www.website.com\")"
    "_cpp_assert_equal(\"\${output}\" \"${dd_line}\")"
)

