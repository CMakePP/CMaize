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

include(cmaize/user_api/dependencies/impl_/check_optional_flag)
include(cmaize/user_api/dependencies/find_dependency)

#[[[
# Wraps the process of finding an optional dependency.
#
# Many build systems have optional dependencies. The inclusion of the dependency
# is usually controlled with a flag (e.g., a variable like ``ENABLE_XXX`` for
# an optional dependency ``XXX``). Because of CMake's verbose nature the logic
# for whether or not the dependency is enabled is usually needed in a few
# places. CMaize is capable of automatically propagating the logic for the
# user, as long as the user tells CMaize the flag that controls the inclusion of
# of the dependency.
#
# When the dependency is enabled this function essentially wraps
# ``cmaize_find_dependency`` and the user should consult the documentation for
# ``cmaize_find_dependency`` to understand the full set of options. When enabled
# CMaize will add a compile definition to the target with the same name as the
# flag (common practice for optional dependencies is to use such a definition
# for enabling/disabling sections of source code).
#
# When the dependency is disabled this function simply creates an interface
# target to serve as a placedholder for the dependency. The interface target
# has no state and linking to/installing the target does nothing.
#
# :param name: The name of the dependency.
# :type name: desc
# :param flag: The variable to use as a flag. Used to name the compile
#    definition.
# :type flag: desc
# :param kwargs: Keyword arguments to forward to ``cmaize_find_dependency``.
#    See the documentation for ``cmaize_find_dependency`` for the full list.
#]]
function(cmaize_find_optional_dependency _cfod_name _cfod_flag)

    # N.B. ${_cfod_flag} is the variable serving as the flag and
    # ${${_cfod_flag}} is its value

    _check_optional_flag("${_cfod_flag}")

    if("${${_cfod_flag}}")
        cmaize_find_dependency("${_cfod_name}" ${ARGN})
        target_compile_definitions("${_cfod_name}" INTERFACE "${_cfod_flag}")
    elseif(NOT TARGET "${_cfod_name}")
        add_library("${_cfod_name}" INTERFACE)
    endif()

endfunction()
