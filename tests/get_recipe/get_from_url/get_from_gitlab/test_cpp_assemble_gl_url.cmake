include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("assemble_gl_url")

set(prefix https://gitlab.com/org/repo/repository)

_cpp_add_test(
TITLE "Basic usage"
"include(get_recipe/get_from_url/get_from_gitlab/assemble_gl_url)"
"_cpp_assemble_gl_url(url org repo \"latest\" \"master\")"
"_cpp_assert_equal(${prefix}/archive.tar.gz \${url})"
)

_cpp_add_test(
TITLE "Honors version"
"include(get_recipe/get_from_url/get_from_gitlab/assemble_gl_url)"
"_cpp_assemble_gl_url(url org repo \"1.2\" \"master\")"
"_cpp_assert_equal(${prefix}/1.2/archive.tar.gz \${url})"
)

_cpp_add_test(
TITLE "Honors branch"
"include(get_recipe/get_from_url/get_from_gitlab/assemble_gl_url)"
"_cpp_assemble_gl_url(url org repo \"latest\" \"branch\")"
"_cpp_assert_equal(${prefix}/branch/archive.tar.gz \${url})"
)
