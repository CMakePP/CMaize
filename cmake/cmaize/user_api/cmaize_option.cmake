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

#[[[
# Registers a configuration option with the current project.
#
#
# .. note::
#
#    Unlike CMake's ``option`` command values are not restricted to booleans.
#
# Build system mainainers can declare configuration options for their build
# system via the ``cmaize_option`` function. Consistent with usual build sytem
# behavior, users can override the default value. Assuming a call to
# ``cmaize_option`` like ``cmaize_option(option_name option_value)``, users of
# the build system can set the value of the ``option_name`` option by:
#
# 1. setting a ``option_name`` variable before calling ``cmaize_option``,
# 2. setting a ``option_name`` cache variable before calling ``cmaize_option``,
#    or by
# 3. setting the configuration option ``option_name`` on the project's
#    CMaizeProject object directly (not recommended for end users).
#
# If the user has not set the value via any of the above mechanisms
# ``cmaize_option`` will set the value of ``option_name`` to ``option_value``.
#
# After calling this function the CMake variable ``option_name`` is guaranteed
# to be set. Similar to CMake's ``option`` command, the CMake cache variable
# ``option_name`` will be set if a normal (or cache) CMake variable
# ``option_name`` was not already set.
#
# :param name: The name of the configuration option being set.
# :type name: desc
# :param default_value: The value to set ``name`` to if the user does not
#    provide a value.
# :type default_value: str
#]]
function(cmaize_option _co_name _co_default_value)
    cpp_get_global(_co_project CMAIZE_TOP_PROJECT)

    # A set CMake variable (this includes CMake's cache) takes precedence over
    # all else
    if(DEFINED "${_co_name}")
        CMaizeProject(
            set_config_option "${_co_project}" "${_co_name}" "${${_co_name}}"
        )
        return()
    endif()

    # 2nd priority is if it was set in the CMaizeProject
    CMaizeProject(
        has_config_option "${_co_project}" _co_has_option "${_co_name}"
    )

    # 3rd priority is the default value
    if(NOT _co_has_option)
        CMaizeProject(
            set_config_option
            "${_co_project}" "${_co_name}" "${_co_default_value}"
        )
    endif()

    # The value we want to use is now set in the CMaizeProject, so get it and
    # set the appropriate CMake variable and cache variable

    CMaizeProject(
        get_config_option "${_co_project}" _co_value "${_co_name}"
    )
    set("${_co_name}" "${_co_value}" CACHE BOOL "" FORCE)
    set("${_co_name}" "${_co_value}" PARENT_SCOPE)

endfunction()
