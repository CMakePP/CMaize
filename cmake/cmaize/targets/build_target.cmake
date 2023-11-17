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
# Wraps a target which must be built as part of the build system.
#]]
cpp_class(BuildTarget CMaizeTarget)

    #[[[
    # :type: path
    #
    # Directory where the target binary will appear after being built.
    #]]
    cpp_attr(CMaizeTarget build_path)

    #[[[
    # :type: List[path]
    #
    # Paths needed to compile or import.
    #]]
    cpp_attr(BuildTarget include_dirs)

    #[[[
    # :type: List[path]
    #
    # Files needed to compile or import.
    #]]
    cpp_attr(BuildTarget includes)

    #[[[
    # :type: ProjectSpecification
    #
    # The project specification for the current project.
    #]]
    cpp_attr(BuildTarget project_specification)

    # #[[[
    # # :type: List[BuildTarget]
    # #
    # # Dependencies that need to be built.
    # #]]
    # cpp_attr(BuildTarget project_dependencies)

    # #[[[
    # # :type: List[InstalledTarget]
    # #
    # # Dependencies that are already installed.
    # #]]
    # cpp_attr(BuildTarget system_dependencies)

    #[[[
    # :type List[CMaizeTarget]
    #
    # Targets that are dependencies.
    #]]
    cpp_attr(BuildTarget depends)

    #[[[
    # Virtual member function for building the target.
    # 
    # :param self: BuildTarget object
    # :type self: BuildTarget
    #]]
    cpp_member(make_target BuildTarget)
    cpp_virtual_member(make_target)

    #[[[
    # Virtual member function to wrap calls to add_library, add_executable,
    # add_custom_target, etc.
    # 
    # :param self: BuildTarget object
    # :type self: BuildTarget
    #]]
    cpp_member(_create_target BuildTarget)
    cpp_virtual_member(_create_target)

    #[[[
    # Virtual member function to set the include directories for the target.
    # 
    # :param self: BuildTarget object
    # :type self: BuildTarget
    #]]
    cpp_member(_set_include_directories BuildTarget)
    cpp_virtual_member(_set_include_directories)

cpp_end_class()
