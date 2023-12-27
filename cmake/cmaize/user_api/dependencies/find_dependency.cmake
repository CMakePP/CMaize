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

include(cmaize/user_api/dependencies/impl_/find_dependency)

#[[[
# Wraps finding a dependency that CMaize can not build.
#
# There are some dependencies which are not easily built, or whose build process
# takes a long time (and thus should be pre-installed). Such dependencies are
# still needed in build systems, but the build system will not be able to build
# them if they are not already installed. This function wraps the process of
# looking for a dependency and aborting the build if an already installed
# variant of the dependency can not be located.
#
# :param name: The name of the dependency we are looking for.
# :type name: desc
# :param **kwargs: Keyword arguments describing the behavior of the search. See
#    the documentation for _fob_parse_arguments for a complete list.
#
# :raises UNKNOWN_PM: When ``pm_name`` does not correspond to a known package
#     manager. Strong throw guarantee.
#]]
function(cmaize_find_dependency _cfd_name)

    cpp_get_global(_cfd_project CMAIZE_TOP_PROJECT)

    _cmaize_find_dependency(
        _cfd_tgt
        _cfd_pm
        _cfd_package_specs
        "${_cfd_project}"
        "${_cfd_name}"
        ${ARGN}
    )

    if("${_cfd_tgt}" STREQUAL "")
        cpp_raise(
            PACKAGE_NOT_FOUND
            "CMaize was unable to locate ${_cfd_name}"
        )
    endif()

endfunction()
