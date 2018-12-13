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

## Function which builds a dependency from a user-provided build module.
#
# :param install: The path to the install root for the dependency.
# :param src: The path to the root of the source tree.
# :param tc: The path to the toolchain file to use for building.
# :param recipe: The path to the build module.
function(_cpp_user_build _cub_install _cub_src _cub_tc _cub_recipe)
    file(READ ${_cub_recipe} _cub_contents)
    _cpp_run_sub_build(
        ${_cub_src}
        NAME external_dependency
        INSTALL_DIR ${_cub_install}
        TOOLCHAIN   ${_cub_tc}
        CONTENTS    "${_cub_contents}"
    )
endfunction()
