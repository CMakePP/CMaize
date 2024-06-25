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

include(cmaize/package_managers/cmake/dependency/detail_/check_target)
include(cmaize/utilities/fetch_and_available)

#[[[
# Models a dependency of the main CMake Project.
#
# The base class is for dependencies which behave close to ideal (from the
# standpoint of CMake). In particular we assume the dependency:
#
# - can be found by calling ``find_package`` in ``CONFIG`` mode
# - added to the main project's build step via CMake's fetch command
# - exports a CMake target
#]]
cpp_class(Dependency)
    #[[[
    # :type: desc
    #
    # Name of the target the dependency is being built.
    #]]
    cpp_attr(Dependency build_target)

    #[[[
    # :type: list[desc]
    #
    # CMake variables that need to be set before building the dependency.
    #]]
    cpp_attr(Dependency cmake_args)

    #[[[
    # :type: desc
    #
    # Name of the target if the dependency is found.
    #]]
    cpp_attr(Dependency find_target)

    #[[[
    # :type: bool
    #
    # If the dependency has been found yet (TRUE) or not (FALSE). Defaults
    # to FALSE.
    #]]
    cpp_attr(Dependency found FALSE)

    #[[[
    # :type: desc
    #
    # Name of the dependency.
    #]]
    cpp_attr(Dependency name)

    #[[[
    # :type: desc
    #
    # This is the target (accounting for build vs. find) to link against.
    # TODO: Is this used anywhere or necessary?
    #]]
    cpp_attr(Dependency target)

    #[[[
    # :type: desc
    #
    # The version of the dependency requested.
    #]]
    cpp_attr(Dependency version)

    #[[[
    # Virtual member to build a dependency.
    #]]
    cpp_member(build_dependency Dependency)
    cpp_virtual_member(build_dependency)

    #[[[
    # Attempts to locate the dependency.
    #
    # :param self: Dependency object
    # :type self: Dependency
    # :param _fd_found: Return variable for whether the dependency was found
    # :type _fd_found: desc
    #
    # :returns: Whether the dependency was found (TRUE) or not (FALSE)
    # :rtype: bool
    #]]
    cpp_member(find_dependency Dependency desc)
    function("${find_dependency}" self _fd_found)

        # Check if it was already found? If so short-circuit and return TRUE
        Dependency(GET "${self}" "${_fd_found}" found)
        message("Was already found? ${${_fd_found}}")
        if("${${_fd_found}}")
            cpp_return("${_fd_found}")
        endif()

        # Wasn't found so call find_package to look for it.
        Dependency(_SEARCH_PATHS "${self}" _fd_paths)
        Dependency(GET "${self}" _fd_name name)
        Dependency(GET "${self}" _fd_version version)
        find_package(
            "${_fd_name}"
            CONFIG
            PATHS "${_fd_paths}"
            NO_PACKAGE_ROOT_PATH
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_PACKAGE_REGISTRY
            NO_CMAKE_SYSTEM_PATH
            NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
        )

        # Is it found now? Record and return the result
        if("${${_fd_name}_FOUND}")
            _cmaize_dependency_check_target("${self}" "find")
            Dependency(SET "${self}" found TRUE)
            set("${_fd_found}" TRUE PARENT_SCOPE)
        else()
            set("${_fd_found}" FALSE PARENT_SCOPE)
        endif()
    endfunction()

    #[[[
    # Initialize the dependency with project information.
    #
    # TODO: Many of these optional arguments could be contained in a
    #       PackageSpecification and seem necessary, not optional, to include
    #       for this class to work. I need to look into it more.
    #
    # :param **kwargs: Additional keyword arguments may be necessary.
    #
    # :Keyword Arguments:
    #    * **BUILD_TARGET** (*desc*) --
    #      Name of the target when it is built. This usually does not include
    #      namespaces yet.
    #    * **FIND_TARGET** (*desc*) --
    #      Name of the target when it is found using something like CMake's
    #      ``find_package()`` tool. This typically does include a namespace.
    #    * **NAME** (*desc*) --
    #      Name used to identify this dependency. This does not need to match
    #      the find or build target names, but frequently will match one or
    #      both.
    #    * **URL** (*desc*) --
    #      URL used to download the source code, if necessary.
    #    * **VERSION** (*desc*) --
    #      Version of the target to find or build.
    #]]
    cpp_member(init Dependency args)
    function("${init}" self)

        set(_i_one_value_args BUILD_TARGET FIND_TARGET NAME URL VERSION)
        cmake_parse_arguments(_i "" "${_i_one_value_args}" "" ${ARGN})

        Dependency(SET "${self}" name "${_i_NAME}")
        Dependency(SET "${self}" location "${_i_URL}")
        Dependency(SET "${self}" version "${_i_VERSION}")
        Dependency(SET "${self}" build_target "${_i_BUILD_TARGET}")
        Dependency(SET "${self}" find_target "${_i_FIND_TARGET}")

    endfunction()

    #[[[ Computes a list of path prefixes which should be used when searching.
    #
    # This function encapsulates assembling a list of all the prefixes which
    # should be considered when looking for this dependency.
    #
    # :param _sp_this: The Dependency instance being used to assemble the paths.
    # :type _sp_this: Dependency
    # :param _sp_result: Name for variable which will hold the result.
    # :type _sp_result: desc
    #]]
    cpp_member(_search_paths Dependency desc)
    function("${_search_paths}" _sp_this _sp_result)

        # Get the name in its native case, in all caps, and all lowercase
        Dependency(GET "${_sp_this}" _sp_name name)
        string(TOUPPER "${_sp_name}" _sp_uc_name)
        string(TOLOWER "${_sp_name}" _sp_lc_name)

        # Add prefix path and XXX_ROOT to the list of paths
        set("${_sp_result}" ${CMAKE_PREFIX_PATH})
        list(APPEND "${_sp_result}" "${${_sp_name}_ROOT}")
        list(APPEND "${_sp_result}" "${${_sp_uc_name}_ROOT}")
        list(APPEND "${_sp_result}" "${${_sp_lc_name}_ROOT}")

        # Possibly some duplicates so clean those up
        list(REMOVE_DUPLICATES "${_sp_result}")

        # Return the paths
        cpp_return("${_sp_result}")
    endfunction()

cpp_end_class()
