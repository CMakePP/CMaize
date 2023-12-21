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

include(cmaize/project/package_specification)

#[[[
# Turns "find or build" kwargs into objects.
#
# .. note::
#
#    The _fob prefix stands for "find or build" and is present to help avoid
#    name collisions in case another user api function decides it wants a
#    "parse_arguemnts" function too.
#
# TODO: Add more versioning options, such as an ``EXACT`` keyword to allow
#       the user to specify that only the given version should be found.
#       As it stands, it finds any version or the exact version if ``VERSION``
#       is given.
#       I propose providing the following options: 1) any available version if
#       no version
#       keyword is given; 2) the provided version, or greater; or 3) the exact
#       version if both ``VERSION`` and ``EXACT`` are provided.
#
# This function serves as the single source of truth for parsing the kwarg input
# to functions in the "find_or_build" family.
#
# :param package_specs: Variable to hold the resulting package specification
# :type package_specs: PackageSpecification*
# :param pm_name: Variable to hold the name of the package manager provided by
#                 the user. Default package manager is CMake.
# :type pm_name: desc*
# :param name: The name of the package
# :type name: desc
# :param **kwargs: The keyword arguments this function will parse.
#
# :Keyword Arguments:
#    * **PACKAGE_MANAGER** --
#      The key associated with the package manager to use.
#    * **VERSION** (*desc*) --
#      Version of the package to find. Defaults to no version ("").
#]]
function(_fob_parse_arguments _fpa_package_specs _fpa_pm_name _fpa_name)

    set(_fpa_one_value_args PACKAGE_MANAGER VERSION)
    cmake_parse_arguments(_fpa "" "${_fpa_one_value_args}" "" ${ARGN})

    PackageSpecification(CTOR _fpa_package_specs_tmp)
    PackageSpecification(SET "${_fpa_package_specs_tmp}" name "${_fpa_name}")

    if(NOT "${_fpa_VERSION}" STREQUAL "")
        PackageSpecification(
            SET "${_fpa_package_specs_tmp}" version "${_fpa_VERSION}"
        )
    endif()

    if("${_fpa_PACKAGE_MANAGER}" STREQUAL "")
        set(_fpa_PACKAGE_MANAGER "cmake")
    endif()

    set("${_fpa_pm_name}" "${_fpa_PACKAGE_MANAGER}" PARENT_SCOPE)
    set("${_fpa_package_specs}" "${_fpa_package_specs_tmp}" PARENT_SCOPE)

endfunction()
