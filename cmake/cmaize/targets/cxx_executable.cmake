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
include(cmaize/targets/cxx_target)

cpp_class(CXXExecutable CXXTarget)

    #[[[
    # Creates the executable target with ``add_executable()``.
    #
    # .. note::
    #
    #    Overrides ``BuildTarget(_create_target``.
    #
    # :param self: CXXExecutable object
    # :type self: CXXExecutable
    #]]
    cpp_member(_create_target CXXExecutable)
    function("${_create_target}" self)
        
        CXXExecutable(target "${self}" _ct_name)
        
        add_executable("${_ct_name}")

    endfunction()

cpp_end_class()
