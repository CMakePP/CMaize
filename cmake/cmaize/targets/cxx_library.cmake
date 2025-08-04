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
include(cmaize/targets/cmaize_library)
include(cmaize/targets/cxx_target)

cpp_class(CXXLibrary CXXTarget CMaizeLibrary)

    cpp_constructor(CTOR CXXLibrary str)
    function("${CTOR}" self _ctor_name)
        message(DEBUG "CTOR of CMaizeLibrary called for \"${_ctor_name}\"")

        CXXTarget(CTOR "${self}" "${_ctor_name}")
        CMaizeLibrary(CTOR "${self}" "${_ctor_name}")
    endfunction()

    #[[[
    # Creates the library target with ``add_library()``.
    #
    # Creates a ``STATIC`` or ``SHARED`` library based on if the variable
    # ``BUILD_SHARED_LIBS`` is ``ON``.
    # 
    # .. note::
    #
    #    Overrides ``BuildTarget(_create_target``.
    #
    # :param self: CXXLibrary object
    # :type self: CXXLibrary
    #]]
    cpp_member(_create_target CXXLibrary)
    function("${_create_target}" self)

        CXXLibrary(target "${self}" _ct_name)
        CXXLibrary(GET "${self}" _ct_lib_type type)
        message(DEBUG "Library type of \"${_ct_name}\" is \"${_ct_lib_type}\"")

        add_library("${_ct_name}" "${_ct_lib_type}")

    endfunction()

cpp_end_class()


