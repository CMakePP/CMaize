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
# URL prefix for GitHub SSH access. Defaults to ``git@github.com``. 
# This option allows for SSH aliases, e.g. ``git@github-alt-account``
# where ``githut-alt-account` is a user-defined alias for GitHub
# SSH access defined in a user's $HOME/.ssh/config.
#]]
cpp_set_global(
    CMAIZE_GITHUB_SSH_PREFIX
    "git@github.com"
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
# Use SSH access for private GitHub repositories toa void OAuth token
# requirements. See ``CMAIZE_GITHUB_SSH_PREFIX`` for details pertaining
# to chaging default GitHub SSH access prefixes.
#]]
cpp_set_global(
    CMAIZE_GITHUB_USE_SSH
    OFF
)

#[[[
# Current CMaize project.
#]]
cpp_set_global(
    CMAIZE_PROJECT
    ""
)

#[[[
# Top-level CMaize project.
#]]
cpp_set_global(
    CMAIZE_TOP_PROJECT
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
