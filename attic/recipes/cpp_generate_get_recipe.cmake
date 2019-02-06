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

## Function which generates the get-recipe for a dependency.
#
# The get-recipe obtains a tarball of a dependency. This function generates the
# callback to be used as the get-recipe. Ultimately, this has two parts:
# providing the appropriate get-recipe API and fixing the arguments to
# :ref:`cpp_get_recipe_dispatch`.
#
# :param output: The identifier used to hold the returned recipe.
# :param url: The URL where the dependency can be located. Should be the empty
#     string if the dependency is not being obtained from the internet.
# :param private: True if the dependency is being downloaded from a private
#     GitHub repository, False if it's a public repo. Ignored if dependency is
#     not obtained from GitHub.
# :param branch: The git branch of the source code to use. Ignored if dependency
#     does not use git for version management.
# :param src: The path to the root of the dependency's source tree. Ignored if
#     dependency is not stored locally.
function(_cpp_generate_get_recipe _cggr_output _cggr_url _cggr_private
         _cggr_branch _cggr_src)
    set(
        ${_cggr_output}
"function(_cpp_get_recipe _cgr_tar _cgr_version)
    include(recipes/cpp_get_recipe_dispatch)
    _cpp_get_recipe_dispatch(
        \"\${_cgr_tar}\"
        \"\${_cgr_version}\"
        \"${_cggr_url}\"
        \"${_cggr_private}\"
        \"${_cggr_branch}\"
        \"${_cggr_src}\"
    )
endfunction()"
        PARENT_SCOPE
    )
endfunction()
