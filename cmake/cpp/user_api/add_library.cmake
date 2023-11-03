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

include(cpp/targets/targets)

function(cpp_add_library _acl_name)
    set(_acl_options SOURCE_DIR INCLUDE_DIR)

    cmake_parse_arguments(_acl "" "${_acl_options}" "" ${ARGN})

    # TODO: Actually establish that we are making a C++ library

    file(GLOB_RECURSE _acl_src
         LIST_DIRECTORIES FALSE
         CONFIGURE_DEPENDS
         "${_acl_SOURCE_DIR}/*.cpp"
         )
    file(GLOB_RECURSE _acl_incs
         LIST_DIRECTORIES FALSE
         CONFIGURE_DEPENDS
         "${_acl_INCLUDE_DIR}/*.hpp"
         )

    list(LENGTH _acl_src _acl_src_n)

    if("${_acl_src_n}" GREATER 0)
        CXXLibrary(CTOR _acl_library)
    else()
        CXXInterfaceLibrary(CTOR _acl_library)
    endif()


    CXXLibrary(
        MAKE_TARGET "${_acl_library}"
        NAME "${_acl_name}"
        INCLUDES "${_acl_incs}"
        SOURCES "${_acl_src}"
        ${ARGN}
    )
endfunction()
