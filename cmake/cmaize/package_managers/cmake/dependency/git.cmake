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

include(cmaize/package_managers/cmake/dependency/dependency_class)
include(cmaize/utilities/fetch_and_available)

cpp_class(GitDependency Dependency)

    #[[[
    # :type: desc
    #
    # URL for the resource
    #]]
    cpp_attr(GitDependency location "")

    #[[[
    # :type: desc
    #
    # Git tag, branch, or commit hash to use. Defaults to "master".
    #]]
    cpp_attr(GitDependency version "master")

    #[[[
    # Attempts to fetch and build the dependency.
    #
    # :param self: Dependency object
    # :type self: Dependency
    #
    #]]
    cpp_member(build_dependency GitDependency)
    function("${build_dependency}" _bd_this)

        GitDependency(GET "${_bd_this}" _bd_url location)
        GitDependency(GET "${_bd_this}" _bd_version version)
        GitDependency(GET "${_bd_this}" _bd_name name)

        # The only reliable way to forward arguments to subprojects seems to be
        # through the cache, so we need to record the current values, set the
        # temporary values, call the subproject, reset the old values
        set(_bd_old_cmake_args)
        foreach(_bd_pair ${_bd_cmake_args})
            string(REPLACE "=" [[;]] _bd_split_pair "${_bd_pair}")
            list(GET _bd_split_pair 0 _bd_var)
            list(GET _bd_split_pair 1 _bd_val)
            list(APPEND _bd_old_cmake_args "${_bd_var}=${${_bd_var}}")
            set("${_bd_var}" "${_bd_val}" CACHE BOOL "" FORCE)
        endforeach()

        cmaize_fetch_and_available(
            "${_bd_name}" 
            GIT_REPOSITORY "${_bd_url}.git"
            GIT_TAG "${_bd_version}"
        )

        foreach(_bd_pair ${_bd_old_cmake_args})
            string(REPLACE "=" [[;]] _bd_split_pair "${_bd_pair}")
            list(GET _bd_split_pair 0 _bd_var)
            list(GET _bd_split_pair 1 _bd_val)
            set("${_bd_var}" "${_bd_val}" CACHE BOOL "" FORCE)
        endforeach()

        _cmaize_dependency_check_target("${_bd_this}" "build")

        # It's now "found" since it's been added to our build system
        Dependency(SET "${_bd_this}" found TRUE)

    endfunction()

    #[[[
    # Initialize the dependency with project information.
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
    #      URL for the GitHub repository. This can be the URL to the
    #      repository or the HTTPS link used to clone the repository, but
    #      not the SSH cloning option.
    #]]
    cpp_member(init GitDependency args)
    function("${init}" self)

        set(_i_options )
        set(_i_one_value_args BUILD_TARGET FIND_TARGET NAME URL VERSION)
        set(_i_list CMAKE_ARGS)
        cmake_parse_arguments(
            _i "${_i_options}" "${_i_one_value_args}" "${_i_list}" ${ARGN}
        )

        GitDependency(SET "${self}" location "${_i_URL}")

        GitDependency(SET "${self}" name "${_i_NAME}")
        GitDependency(SET "${self}" version "${_i_VERSION}")
        GitDependency(SET "${self}" build_target "${_i_BUILD_TARGET}")
        GitDependency(SET "${self}" find_target "${_i_FIND_TARGET}")
        GitDependency(SET "${self}" cmake_args "${_i_CMAKE_ARGS}")

    endfunction()

cpp_end_class()
