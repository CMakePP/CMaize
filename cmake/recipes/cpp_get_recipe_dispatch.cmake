################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()
include(recipes/cpp_url_dispatcher)

## Function which starts the process for getting a dependency.
#
# Ultimately the process of getting a dependency relies on double dispatch. This
# function performs the first dispatch, which dispatches based on whether or not
# our source code is coming form a URL or a local directory.
#
# :param tar: The path to the tarball that should hold the resulting source.
# :param version: The version of the source code to obtain.
# :param url: The URL where the dependency can be located. Should be the empty
#     string if the dependency is not being obtained from the internet.
# :param private: True if the dependency is being downloaded from a private
#     GitHub repository, False if it's a public repo. Ignored if dependency is
#     not obtained from GitHub.
# :param branch: The git branch of the source code to use. Ignored if dependency
#     does not use git for version management.
# :param src: The path to the root of the dependency's source tree. Ignored if
#     dependency is not stored locally.
function(_cpp_get_recipe_dispatch _cgrd_tar _cgrd_version _cgrd_url
         _cgrd_private _cgrd_branch _cgrd_src)
    #Get the file's contents
    if(_cgrd_url)
        _cpp_url_dispatcher(
            ${_cgrd_tar}
            "${_cgrd_version}"
            "${_cgrd_url}"
            "${_cgrd_private}"
            "${_cgrd_branch}"
        )
    elseif(_cgrd_src)
        _cpp_tar_directory(${_cgrd_tar} ${_cgrd_src})
    else()
        _cpp_error(
            "Not sure how to get source for dependency. "
            "Troubleshooting: Did you specify URL or SOURCE_DIR?"
        )
    endif()
endfunction()
