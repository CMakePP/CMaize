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
include(utility/set_return)

## Function for creating and installing a dummy C++ package.
#
# This function piggybacks off of :ref:`cpp_dummy_cxx_package-label`. After the
# package is created this function additionally calls :ref:`cpp_run_sub_build`
# to build the package. The resulting package is installed to
# ``<prefix>/install``. Note that the resulting package is installed with a
# config file that can locate it. For installing a less well written library
# consider :ref:`cpp_install_naive_cxx_package`.
#
# :param prefix: The directory in which the package should be generated.
# :param install: The directory where the package is installed.
# :kwargs:
#
#     * *NAME* - The name of the package. Defaults to "dummy".
function(_cpp_install_dummy_cxx_package _cidcp_install _cidcp_prefix)
    cmake_parse_arguments(_cidcp "" "NAME" "" ${ARGN})
    cpp_option(_cidcp_NAME dummy)
    _cpp_dummy_cxx_package(_cidcp_root ${_cidcp_prefix} NAME ${_cidcp_NAME})
    _cpp_run_sub_build(
        ${_cidcp_root}
        INSTALL_DIR ${_cidcp_prefix}/install
        NAME ${_cidcp_NAME}
    )
    _cpp_set_return(${_cidcp_install} ${_cidcp_prefix}/install)
endfunction()
