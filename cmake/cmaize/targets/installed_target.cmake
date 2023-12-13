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
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/cmaize_target)

#[[[
# Wraps a target that is already installed on the system.
#]]
cpp_class(InstalledTarget CMaizeTarget)

    #[[[
    # :type: path
    #
    # The root directory of the installation.
    #]]
    cpp_attr(InstalledTarget root_path)

    #[[[
    # Instantiate a target for a resource that is already installed.
    #
    # :param self: InstalledTarget object
    # :type self: InstalledTarget
    # :param root: The top of the install location for the resource. Must
    #              already exist.
    # :type root: path
    #
    # :returns: ``self`` will be set to the new instance of ``InstalledTarget``
    # :rtype: InstalledTarget
    #
    # :raises DirectoryNotFound: Root directory was not found.
    #]]
    cpp_constructor(CTOR InstalledTarget str path)
    function("${CTOR}" self _ctor_name _ctor_root)

        CMaizeTarget(CTOR "${self}" "${_ctor_name}")

        # Check if the root path exists
        cpp_directory_exists(exists "${_ctor_root}")
        if(NOT exists)
            set(msg "InstalledTarget root directory not found. ")
            string(APPEND msg "Root given: '${_ctor_root}'")
            cpp_raise(DirectoryNotFound "${msg}")
        endif()

        InstalledTarget(SET "${self}" root_path "${_ctor_root}")

    endfunction()

cpp_end_class()
