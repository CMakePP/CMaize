include_guard()

#[[[
# File extensions for CXX header files. This is the counterpart to
# ``CMAKE_CXX_SOURCE_FILE_EXTENSIONS``.
#]]
set(
    CMAIZE_CXX_INCLUDE_FILE_EXTENSIONS
    H
    h
    HPP
    hpp
    HXX
    hxx
    HH
    hh
)

#[[[
# GitHub token used to access private repositories. It is defaulted to the
# value of the old ``CPP_GITHUB_TOKEN`` for backwards compatability and
# will be a blank string ("") if ``CPP_GITHUB_TOKEN`` does not exist.
#]]
set(
    CMAIZE_GITHUB_TOKEN
    "${CPP_GITHUB_TOKEN}"
)

#[[[
# Current CMaize project.
#]]
set(
    CMAIZE_PROJECT
    ""
)

#[[[
# Languages supported by CMaize.
#]]
set(
    CMAIZE_SUPPORTED_LANGUAGES
    CXX
)

#[[[
# Package manager options supported by CMaize.
#]]
set(
    CMAIZE_SUPPORTED_PACKAGE_MANAGERS
    CMake
)
