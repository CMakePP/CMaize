include_guard()
include(cmakepp_lang/cmakepp_lang)

#[[[
# File extensions for CXX header files. This is the counterpart to
# ``CMAKE_CXX_SOURCE_FILE_EXTENSIONS``.
#]]
cpp_set_global(
    CMAIZE_CXX_INCLUDE_FILE_EXTENSIONS
    "H;h;HPP;hpp;HXX;hxx;HH;hh"
)

#[[[
# GitHub token used to access private repositories. It is defaulted to the
# value of the old ``CPP_GITHUB_TOKEN`` for backwards compatability and
# will be a blank string ("") if ``CPP_GITHUB_TOKEN`` does not exist.
#]]
cpp_set_global(
    CMAIZE_GITHUB_TOKEN
    "${CPP_GITHUB_TOKEN}"
)

#[[[
# Current CMaize project.
#]]
cpp_set_global(
    CMAIZE_PROJECT
    ""
)

#[[[
# Languages supported by CMaize.
#]]
cpp_set_global(
    CMAIZE_SUPPORTED_LANGUAGES
    CXX
)

#[[[
# Package manager options supported by CMaize.
#]]
cpp_set_global(
    CMAIZE_SUPPORTED_PACKAGE_MANAGERS
    CMake
)
