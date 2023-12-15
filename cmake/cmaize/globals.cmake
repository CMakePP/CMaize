# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
# GitHub token used to access private repositories. It is empty by default.
#]]
cpp_set_global(
    CMAIZE_GITHUB_TOKEN
    ""
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
    cmake
)
