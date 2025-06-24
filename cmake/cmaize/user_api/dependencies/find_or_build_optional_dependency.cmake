# Copyright 2024, 2025 CMakePP
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
include(cmaize/user_api/dependencies/find_or_build_dependency)
include(cmaize/targets/cmaize_target)

#[[[
# Wraps the process of finding or building an optional dependency.
#
# This method is largely the same as cmaize_find_optional_dependency, but
# instead wraps a call to ``cmaize_find_or_build_dependency``. However, when
# the provided option is enabled, the optional flag is also added as a compile
# definition on the dependency target. This propagates the optional flag as a
# compile definition to any targets that depend on this target.
#
# When the option is disabled, an empty interface library target is created
# instead, essentially a no-op when added as a link target. This ensures that
# a target always exists and the CMaize target identifier can be used
# regardless of whether the optional dependency is enabled or not.
#
# .. note::
#
#    The compile definition for the optional flag that is added to the target
#    will NOT include the value assigned to the optional flag.
#
# :param name: A name for the dependency for CMaize. This is assumed to also
#     be the name of the package to be found unless ``NAME`` is provided.
# :type name: desc
# :param flag: The variable to use as a flag. Used to name the compile
#    definition.
# :type flag: desc
# :param kwargs: Keyword arguments to forward to
#    ``cmaize_find_or_build_dependency``. See the documentation for
#    ``cmaize_find_or_build_dependency`` for the full list.
#
# :raises UNKNOWN_PM: ``PACKAGE_MANAGER`` does not correspond to a known
#     package manager. Strong throw guarantee
# :raises TargetNotFound: Target does not exist on the CMaize project after
#     ``cmaize_find_or_build_dependency()``. ??? throw guarantee.
#]]
function(cmaize_find_or_build_optional_dependency _cfobod_name _cfobod_flag)

    _check_optional_flag("${_cfobod_flag}")

    # Get the top CMaize project so we can look up the target that
    # was just created from cmaize_find_or_build_dependency()
    cpp_get_global(_cfobod_top_proj_obj CMAIZE_TOP_PROJECT)

    set(_cfobod_tgt_obj "")
    if("${${_cfobod_flag}}")
        message(VERBOSE "\"${_cfobod_name}\" enabled with ${_cfobod_flag} = ${${_cfobod_flag}}")

        # Find or build the dependency target, adding it to the cmaize project
        cmaize_find_or_build_dependency("${_cfobod_name}" ${ARGN})

        # Use the ALL flag to check both installed and built targets in the
        # project, since the target may be stored under either
        CMaizeProject(get_target
            "${_cfobod_top_proj_obj}"
            _cfobod_tgt_obj
            "${_cfobod_name}"
            ALL
        )

        # CMaizeProject(get_target should never fail to find this target,
        # it will be added by cmaize_find_or_build_dependency() in one form
        # or another.
        # NOTE: This could be a cpp_assert call, but currently an empty string
        # does not evaluate to false in cpp_assert, so an alternative was used.
        if("${_cfobod_tgt_obj}" STREQUAL "")
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
        CMaizeTarget(target "${_cfobod_tgt_obj}" _cfobod_tgt_name)
        target_compile_definitions(
            "${_cfobod_tgt_name}" INTERFACE "${_cfobod_flag}"
        )
    else()
        message(VERBOSE "\"${_cfobod_name}\" disabled with ${_cfobod_flag} = ${${_cfobod_flag}}")

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
        # enabled in the top level package? However unlikely, it is a state
        # that should be handled here.

        # Use the ALL flag to check both installed and built targets in the
        # project, since the target may be stored under either.
        CMaizeProject(check_target
            "${_cfobod_top_proj_obj}"
            _cfobod_tgt_found
            "${_cfobod_name}"
            ALL
        )

        # If CMaize finds that the target is already defined for the project,
        # just use that and move on. Someone has done our work for us already.
        #
        # Otherwise, we need to create it here.
        if(NOT "${_cfobod_tgt_found}")
            # Wrap the target in a CMaizeTarget
            CMaizeTarget(ctor
                _cfobod_tgt_obj
                "${_cfobod_name}"
            )

            # Add the dummy CMaize target to the project
            CMaizeProject(add_target
                "${_cfobod_top_proj_obj}"
                "${_cfobod_name}"
                "${_cfobod_tgt_obj}"
            )

            # Create the dummy CMake target if it doesn't exist yet
            if(NOT TARGET "${_cfobod_name}")
                add_library("${_cfobod_name}" INTERFACE)
            endif()
        endif()
    endif()

endfunction()
