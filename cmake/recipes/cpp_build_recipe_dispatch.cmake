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
include(recipes/cpp_user_build)
include(recipes/cpp_configure_dispatch)

## Function starting the build process for a dependency.
#
# Ultimately we do double dispatch with respect to building a dependency. This
# function handles the first dispatch, which occurs based on whether or not CPP
# is attempting to automatically build the dependency. If we are not, then we
# call :ref:`cpp_user_build-label`, if we are automatically building the
# dependency then we call :ref:`cpp_configure_dispatch-label`.
#
# :param install: The path to the root of the install tree where the dependency
#     should go.
# :param src: The path to the source code we are building lives.
# :param tc: The path to the toolchain file to use for building.
# :param args: The additional CMake arguments to provide to the dependency. If
#     there are no such arguments, pass the empty string.
# :param module: The path to the build module file the user provided. If no such
#     file was provided pass the empty string.
function(_cpp_build_recipe_dispatch _cbrd_install _cbrd_src _cbrd_tc _cbrd_args
                                    _cbrd_module)
    _cpp_is_not_empty(_cbrd_user_recipe _cbrd_module)
    if(_cbrd_user_recipe)
        _cpp_user_build(
            ${_cbrd_install}
            ${_cbrd_src}
            ${_cbrd_tc}
            ${_cbrd_module}
            "${_cbrd_args}"
        )
    else()
        _cpp_configure_dispatch(
            ${_cbrd_install} ${_cbrd_src} ${_cbrd_tc} "${_cbrd_args}"
        )
    endif()
endfunction()
