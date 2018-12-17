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

## Function which generates the find-recipe for a dependency.
#
# The find-recipe searches for an installed version of a dependency. This
# function generates the callback to be used as the find-recipe. Ultimately,
# this has two parts: providing the appropriate find-recipe API and fixing the
# arguments to :ref:`cpp_find_recipe_dispatch`.
#
# :param output: The identifier used to hold the returned recipe.
# :param module: The path to the find module that the user provided. If no
#     module was provided then pass the empty string.
function(_cpp_generate_find_recipe _cgfr_output _cgfr_name _cgfr_module)
    set(
        ${_cgfr_output}
"function(_cpp_find_recipe _cfr_found _cfr_version _cfr_comps _cfr_path)
    include(recipes/cpp_find_recipe_dispatch)
    _cpp_find_recipe_dispatch(
        _cfr_was_found
        \"${_cgfr_name}\"
        \"\${_cfr_version}\"
        \"\${_cfr_comps}\"
        \"\${_cfr_path}\"
        \"${_cgfr_module}\"
    )
    set(\${_cfr_found} \${_cfr_was_found} PARENT_SCOPE)
endfunction()"
        PARENT_SCOPE
    )
endfunction()
