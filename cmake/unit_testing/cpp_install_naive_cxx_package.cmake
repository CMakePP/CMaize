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
include(unit_testing/cpp_naive_cxx_package)

## Writes and installs a C++ package that uses CMake naively.
#
# This function is a thin wrapper around :ref:`cpp_naive_cxx_package-label` that
# additionally builds and installs the resulting package.
#
# :param install: An identifier which, after this call, will contain the path to
#     the install directory.
# :param prefix: The path to a directory which will contain both the source and
#     the installed library.
#
# :kwargs:
#
#     * *NAME* (``option``) - The name of the dependency. Defaults to "dummy".
function(_cpp_install_naive_cxx_package _cincp_install _cincp_prefix)
    _cpp_naive_cxx_package(_cincp_src ${_cincp_prefix} ${ARGN})
    _cpp_run_sub_build(
        ${_cincp_src} INSTALL_DIR ${_cincp_prefix}/install NAME install_naive
    )
    set(${_cincp_install} ${_cincp_prefix}/install PARENT_SCOPE)
endfunction()
