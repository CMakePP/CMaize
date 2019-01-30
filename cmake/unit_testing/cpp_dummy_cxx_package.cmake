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

## Function for creating a C++ package for testing purposes.
#
# This function uses :ref:`cpp_dummy_cxx_library-label` to generate C++ source
# code for a simple library. In addition to the source code, this function also
# creates a ``CMakeLists.txt`` that can be used to build the package. The
# resulting ``CMakeLists.txt`` is written in terms of CPP commands and will
# create config files for finding the dependency upon installation. For testing
# less well written CMake projects use :ref:`cpp_naive_cxx_package-label`.
#
# :param dir: An identifier which upon return will contain the path to the
#             package's root directory.
# :param prefix: The directory where the package will be created. The source for
#     the resulting package will reside at ``<prefix>/<name>``.
#
# :kwargs:
#
#     * *NAME* (``option``) - The name of the package we are creating. Defaults
#       to dummy.
function(_cpp_dummy_cxx_package _cdcp_dir _cdcp_prefix)
    set(_cdcp_O_kwargs NAME)
    cmake_parse_arguments(_cdcp "" "NAME" "" ${ARGN})
    cpp_option(_cdcp_NAME dummy)
    set(_cdcp_root ${_cdcp_prefix}/${_cdcp_NAME})
    _cpp_dummy_cxx_library(${_cdcp_root})
    _cpp_write_list(
            ${_cdcp_root}
            NAME ${_cdcp_NAME}
            CONTENTS "include(cpp_targets)"
            "cpp_add_library("
            "  ${_cdcp_NAME}"
            "  SOURCES  a.cpp"
            "  INCLUDES a.hpp"
            ")"
            "cpp_install(TARGETS ${_cdcp_NAME})"
    )
    _cpp_set_return(${_cdcp_dir} ${_cdcp_prefix}/${_cdcp_NAME})
endfunction()
