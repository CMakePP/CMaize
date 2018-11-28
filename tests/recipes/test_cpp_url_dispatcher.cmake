include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("url_dispatcher")


#No idea why, but it won't match anymore...
set(gh_include "include(recipes/cpp_get_from_gh)")
set(gh_prefix "_cpp_get_from_gh(\\\${_cgr_tar} \\\${_cgr_version} ")

_cpp_add_test(
TITLE "Basic GitHub usage"
CONTENTS
    "include(recipes/cpp_url_dispatcher)"
    "_cpp_url_dispatcher(output github.com/org/repo)"
    "_cpp_assert_contains(\"${gh_include}\" \"\${output}\")"
    "_cpp_assert_contains(\"${gh_prefix}\" \"\${output}\")"
)


set(dd_line "_cpp_download_tarball(\\\${_cgr_tar} www.website.com)")
_cpp_add_test(
TITLE "Direct download link"
CONTENTS
    "include(recipes/cpp_url_dispatcher)"
    "_cpp_url_dispatcher(output \"www.website.com\")"
    "_cpp_assert_equal(\"\${output}\" \"${dd_line}\")"
)

