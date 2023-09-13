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
include(cpp/targets/cxx_executable)

function(cpp_add_executable _ae_name)
    cmake_parse_arguments(_ae "" "SOURCE_DIR" "" ${ARGN})

    # TODO: Actually establish that we are making a C++ executable

    file(GLOB_RECURSE _ae_src
         LIST_DIRECTORIES FALSE
         CONFIGURE_DEPENDS
         "${_ae_SOURCE_DIR}/*.cpp"
    )

    CXXExecutable(CTOR _ae_exe)
    CXXExecutable(
        MAKE_TARGET "${_ae_exe}"
        NAME "${_ae_name}"
        SOURCES ${_ae_src}
        ${ARGN}
    )
endfunction()
