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
cpp_class(CMaizeInterfaceLibrary CMaizeLibrary)

    #[[[
    # Creates a ``CMaizeInterfaceLibrary`` object to manage a target of the given name.
    # 
    # .. note::
    #    
    #    This does not create a corresponding CMake target,
    #    so any call that should interact with a target will fail if the
    #    target does not already exist. As a base class with no concrete
    #    analog, ``CMaizeInterfaceLibrary`` really shouldn't be instantiated aside from
    #    testing purposes. Instead, create a child with a concrete target
    #    analog and instantiate that.
    #
    # :param self: CMaizeInterfaceLibrary object constructed.
    # :type self: CMaizeInterfaceLibrary
    # :param tgt_name: Name of the target. This should not duplicate any other
    #                  target name already in scope.
    # :type tgt_name: desc or target
    #
    # :returns: ``self`` will be set to the newly constructed ``CMaizeInterfaceLibrary``
    #           object.
    # :rtype: CMaizeInterfaceLibrary
    #]]
    cpp_constructor(CTOR CMaizeInterfaceLibrary str)
    function("${CTOR}" self _ctor_name)

        # Set the library type
        CMaizeLibrary(CTOR "${self}" "${_ctor_name}")
        CMaizeInterfaceLibrary(SET "${self}" type "INTERFACE")

    endfunction()

cpp_end_class()

