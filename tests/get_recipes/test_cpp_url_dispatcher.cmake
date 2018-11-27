include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("url_dispatcher")

set(corr_gh_url "https://api.github.com/repos/org/repo/tarball/master")

set(contents
"function(_cpp_get_recipe _cgr_tar _cgr_version)
    _cpp_get_gh_url(
        _cgr_url
        URL github.com/org/repo
        VERSION \\\"\\\${_cgr_version}\\\"
        ${empty}
    )
    _cpp_download_tarball(\\\${_cgr_tar} \\\${_cgr_url})
endfunction()"
)

_cpp_add_test(
TITLE "GitHub URL"
CONTENTS
    "_cpp_url_dispatcher(test \"github.com/org/repo\")"
    "_cpp_assert_equal(\"${contents}\" \"\${test}\")"
)

set(contents
"function(_cpp_get_recipe _cgr_tar _cgr_version)
    set(_cgr_url www.website.com)
    _cpp_download_tarball(\\\${_cgr_tar} \\\${_cgr_url})
endfunction()"
)


_cpp_add_test(
TITLE "Direct download link"
CONTENTS
    "_cpp_url_dispatcher(test \"www.website.com\")"
    "_cpp_assert_equal(\"${contents}\" \"\${test}\")"
)

