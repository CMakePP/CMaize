# Copyright 2025 CMakePP
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
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/cmaize_target)


#[[[
# Base class for all CMaize libraries.
#]]
cpp_class(CMaizeLibrary CMaizeTarget)

    #[[[
    # :type: desc
    #
    # Library type as defined by <type> in CMake's `add_library
    # <https://cmake.org/cmake/help/latest/command/add_library.html>`__
    # command.
    #
    # Defaults to the value of BUILD_SHARED_LIBS
    #]]
    cpp_attr(CMaizeLibrary type "${BUILD_SHARED_LIBS}")

    # TODO: Function doc
    cpp_constructor(CTOR CMaizeLibrary str)
    function("${CTOR}" self _ctor_name)

        CMaizeTarget(CTOR "${self}" "${_ctor_name}")

        if(BUILD_SHARED_LIBS)
            CMaizeLibrary(SET "${self}" type "SHARED")
        else()
            CMaizeLibrary(SET "${self}" type "STATIC")
        endif()

    endfunction()

cpp_end_class()

