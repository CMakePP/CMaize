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
#
# :raises PACKAGE_NOT_FOUND: CMaize was unable to locate the package specified.
#     Strong throw guarantee.
# :raises UNKNOWN_PM: ``PACKAGE_MANAGER`` does not correspond to a known
#     package manager. Strong throw guarantee.
#]]
function(cmaize_find_optional_dependency _cfod_name _cfod_flag)

    # N.B. ${_cfod_flag} is the variable serving as the flag and
    # ${${_cfod_flag}} is its value

    _check_optional_flag("${_cfod_flag}")

    # Get the top CMaize project so we can look up the target that
    # was just created from cmaize_find_or_build_dependency()
    cpp_get_global(_cfod_top_proj_obj CMAIZE_TOP_PROJECT)

    set(_cfod_tgt_obj "")
    if("${${_cfod_flag}}")
        message(VERBOSE "\"${_cfod_name}\" enabled with ${_cfod_flag} = ${${_cfod_flag}}")

        # Find or build the dependency target, adding it to the cmaize project.
        cmaize_find_dependency("${_cfod_name}" ${ARGN})

        # cmaize_find_dependency() raises PACKAGE_NOT_FOUND if dependency is
        # not found, so no further checking if the target exists is needed

        # Get the target that was found
        CMaizeProject(get_target
            "${_cfod_top_proj_obj}"
            _cfod_tgt_obj
            "${_cfod_name}"
            INSTALLED
        )

        # CMaizeProject(get_target should never fail to find the target at
        # this point.
        # NOTE: This should be a cpp_assert call, but currently an empty string
        # does not evaluate to false in cpp_assert, so an alternative was used.
        if("${_cfod_tgt_obj}" STREQUAL "")
            cpp_raise(TargetNotFound
                "Target was not found in the project, but it should have been \
                added by cmaize_find_or_build_dependency()!"
            )
        endif()

        # Add the flag to the compile definitions of the dependency target.
        # NOTE: It seems that 'target_compile_definitions' will not override
        #       an existing definition, instead prepending the new definition:
        #       https://gitlab.kitware.com/cmake/cmake/-/issues/24099.
        #       To override an existing compile definition here, we would need
        #       to check the INTERFACE_COMPILE_FEATURES target property and
        #       replace the corresponding value if it exists.
        CMaizeTarget(target "${_cfod_tgt_obj}" _cfod_tgt_name)
        target_compile_definitions(
            "${_cfod_tgt_name}" INTERFACE "${_cfod_flag}"
        )
    else()
        message(VERBOSE "\"${_cfod_name}\" disabled with ${_cfod_flag} = ${${_cfod_flag}}")

        # Even if the flag was not set, we still need a dummy target when the
        # dependency is not included. This target should be set up such that 
        # it is effectively a no-op when used during the build process later
        # on, with its only purpose being to propagate the compile definition
        # matching the fobod flag that toggles the target.
        #
        # This target should be defined on the CMaize side as well as CMake side:
        #   CMaize side -> Create a CMaizeTarget object containing the name of the
        #                  CMake target.
        #   CMake side -> add_library("<target_name>" INTERFACE)

        # TODO: Currently entries in the package manager are not being
        # considered, nor is the dummy package being registered with it. Since
        # that is typically where many of the kwargs are parsed, it is
        # difficult to get the NAME value or the build or find target names
        # without creating a Dependency object here.

        # TODO: What happens when a package is disabled for a dependency, but
        #       enabled in the top level package? However unlikely, it is a
        #       state that should be handled here.

        # Use the ALL flag to check both installed and built targets in the
        # project, since an existing target may be stored under either.
        CMaizeProject(check_target
            "${_cfod_top_proj_obj}"
            _cfod_tgt_found
            "${_cfod_name}"
            ALL
        )

        # If CMaize finds that the target is already defined for the project,
        # just use that and move on. Someone has done our work for us already.
        #
        # Otherwise, we need to create it here.
        if(NOT "${_cfod_tgt_found}")
            # Wrap the target in a CMaizeTarget
            CMaizeTarget(ctor
                _cfod_tgt_obj
                "${_cfod_name}"
            )

            # Add the dummy CMaize target to the project
            # TODO: Should this be added as an INSTALLED target?
            CMaizeProject(add_target
                "${_cfod_top_proj_obj}"
                "${_cfod_name}"
                "${_cfod_tgt_obj}"
            )

            # Create the dummy CMake target if it doesn't exist yet
            if(NOT TARGET "${_cfod_name}")
                add_library("${_cfod_name}" INTERFACE)
            endif()
        endif()
    endif()

endfunction()
