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
include(cmaize/targets/cxx_library)

cpp_class(CXXInterfaceLibrary CXXLibrary)

    #[[[
    # Get the access level for the target.
    #
    # .. note::
    # 
    #    Implements ``CXXTarget(_access_level``.
    #
    # :param self: CXXInterfaceLibrary object
    # :type self: CXXInterfaceLibrary
    # :param _al_result: Return variable holding the access level result.
    # :type _al_result: desc*
    #
    # :returns: Access level of the target.
    # :rtype: desc
    #]]
    cpp_member(_access_level CXXInterfaceLibrary desc)
    function("${_access_level}" self _al_result)

        set("${_al_result}" INTERFACE)
        cpp_return("${_al_result}")
    
    endfunction()

    #[[[
    # Creates the interface library target with ``add_library()``.
    #
    # .. note::
    #
    #    Overrides ``BuildTarget(_create_target``.
    #
    # :param self: CXXInterfaceLibrary object
    # :type self: CXXInterfaceLibrary
    #]]
    cpp_member(_create_target CXXInterfaceLibrary)
    function("${_create_target}" self)

        CXXInterfaceLibrary(target "${self}" _it_name)
        
        add_library("${_it_name}" INTERFACE)

    endfunction()

    #[[[
    # CMake doesn't let interface libraries set their public headers, so
    # this function is a no-op.
    #
    # .. note::
    #
    #    Overrides ``CXXTarget(_set_public_headers``.
    #
    # :param self: CXXInterfaceLibrary object
    # :type self: CXXInterfaceLibrary
    #]]
    cpp_member(_set_public_headers CXXInterfaceLibrary)
    function("${_set_public_headers}" self)
        
    endfunction()
cpp_end_class()
