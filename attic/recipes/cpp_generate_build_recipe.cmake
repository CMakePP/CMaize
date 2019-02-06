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

## Function which generates the build-recipe for a dependency.
#
# The build-recipe configures, builds, and installs the dependency. This
# function generates the callback to be used as the build-recipe. Ultimately,
# this has two parts: providing the appropriate build-recipe API and fixing the
# arguments to :ref:`cpp_build_recipe_dispatch`.
#
# :param output: The identifier used to hold the returned recipe.
# :param args: The list of additional CMake Arguments to provide the sub-build.
#     If no additional arguments are needed pass the empty string.
# :param module: If the user provided a build module this is the full path to
#     that module, otherwise it's the empty string.
function(_cpp_generate_build_recipe _cgbr_output _cgbr_args _cgbr_module)
    set(
        ${_cgbr_output}
"function(_cpp_build_recipe _cbr_install _cbr_src _cbr_tc)
    include(recipes/cpp_build_recipe_dispatch)
    _cpp_build_recipe_dispatch(
        \"\${_cbr_install}\"
        \"\${_cbr_src}\"
        \"\${_cbr_tc}\"
        \"${_cgbr_args}\"
        \"${_cgbr_module}\"
    )
endfunction()"
        PARENT_SCOPE
    )
endfunction()
