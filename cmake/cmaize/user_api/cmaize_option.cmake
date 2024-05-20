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
# .. note::
#
#    Unlike CMake's ``option`` command values are not restricted to booleans.
#
# Build system mainainers can declare configuration options for their build
# system via the ``cmaize_option`` function. Consistent with usual build sytem
# behavior, users can override the default value. Assuming a call to
# ``cmaize_option`` like
# ``cmaize_option(option_name option_value option_description)``, users of
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
# :param docstring: A brief description of what the option does. This
#    parameter's value is used primarily as metadata.
# :type docstring: str
#
#]]
function(cmaize_option _co_name _co_default_value _co_docstring)

    cpp_get_global(_co_project CMAIZE_TOP_PROJECT)

    # A set CMake variable (this includes CMake's cache) takes precedence over
    # all else
    if((DEFINED "${_co_name}") AND (NOT "${${_co_name}}" STREQUAL ""))
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
    set("${_co_name}" "${_co_value}" CACHE STRING "${_co_docstring}" FORCE)
    set("${_co_name}" "${_co_value}" PARENT_SCOPE)

endfunction()

#[[[
# Convenience function for registering a number of options with CMaize.
#
# Many projects have multiple configuration options. Rather than having to call
# ``cmaize_option`` for each option, ``cmaize_option_list`` allows you to
# provide a list of key/value pairs. Under the hood this function simply loops
# over the key/value pairs and forwards them to ``cmaize_option``, thus all
# documentation relating to ``cmaize_option`` applies here as well.
#
# :param *args: A variadiac list of key/value pairs. The ``2i``-th argument will
#    be interpretted as the key for the ``i``-th pair and the ``2i + 1``-th
#    argument will be interpretted as the value for the ``i``-th pair.
# :type *args: str
#
# :raises input_error: If the number of arguments is not divisible by 2.
#]]
function(cmaize_option_list)
    set(_col_nargs "${ARGC}")

    # Early out if no arguments were provided (otherwise math below won't work)
    if("${ARGC}" EQUAL "0")
        return()
    endif()


    # Verify we got an appropriate number of arguments
    math(EXPR _col_are_triples "${_col_nargs} % 3")
    if(NOT "${_col_are_triples}" EQUAL "0")
        cpp_raise(
            input_error
            "Syntax: cmaize_option_list(key0 value0 desc0 key1 value1 desc1...)"
        )
    endif()

    # Loops are inclusive on the end point, so subtract 1
    math(EXPR _col_nargs "${_col_nargs} - 1")

    # ARGN isn't actually a variable, so make a list from its contents
    set(_col_argn "${ARGN}")

    # Loop over pairs forwarding them to cmaize_option
    foreach(_col_i RANGE 0 "${_col_nargs}" 3)

        # Work out indices
        set(_col_key_i "${_col_i}")
        math(EXPR _col_value_i "${_col_i} + 1")
        math(EXPR _col_desc_i "${_col_i} + 2")

        # Extract values
        list(GET _col_argn ${_col_key_i} _col_key)
        list(GET _col_argn ${_col_value_i} _col_value)
        list(GET _col_argn ${_col_desc_i} _col_desc)

        # Forward values
        cmaize_option("${_col_key}" "${_col_value}" "${_col_desc}")

    endforeach()

endfunction()
