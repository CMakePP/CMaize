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

cpp_class(RemoteURLDependency Dependency)

    #[[[
    # :type: desc
    #
    # URL for the resource
    #]]
    cpp_attr(RemoteURLDependency location "")

    #[[[
    # Updates the values of the CMake cache to be consistent with the values
    # requested by this dependency.
    #
    # :param old_cmake_args: Variable to assign the old values to.
    # :type old_cmake_args: desc*
    #]]]

    cpp_member(_cache_args RemoteURLDependency desc*)
    function("${_cache_args}" _ca_this _ca_old_cmake_args)
        RemoteURLDependency(GET "${_ca_this}" _ca_cmake_args cmake_args)

        # The only reliable way to forward arguments to subprojects seems to be
        # through the cache, so we need to record the current values, set the
        # temporary values, call the subproject, reset the old values
        foreach(_ca_pair ${_ca_cmake_args})
            string(REPLACE "=" [[;]] _ca_split_pair "${_ca_pair}")
            list(GET _ca_split_pair 0 _ca_var)
            list(GET _ca_split_pair 1 _ca_val)
            list(APPEND "${_ca_old_cmake_args}" "${_ca_var}=${${_ca_var}}")
            set("${_ca_var}" "${_ca_val}" CACHE BOOL "" FORCE)
        endforeach()
        cpp_return("${_ca_old_cmake_args}")
    endfunction()

    #[[[
    # Restores the values in the CMake cach to those in old_cmake_args.
    #
    # :param old_cmake_args: The values to put back into the cache.
    # :type old_cmake_args: desc*
    #]]
    cpp_member(_uncache_args RemoteURLDependency desc*)
    function("${_uncache_args}" _ua_this _ua_old_cmake_args)
        foreach(_ua_pair ${${_ua_old_cmake_args}})
            string(REPLACE "=" [[;]] _ua_split_pair "${_ua_pair}")
            list(GET _ua_split_pair 0 _ua_var)
            list(GET _ua_split_pair 1 _ua_val)
            set("${_ua_var}" "${_ua_val}" CACHE BOOL "" FORCE)
        endforeach()
    endfunction()

    #[[[
    # Attempts to fetch and build the dependency.
    #
    # :param self: Dependency object
    # :type self: Dependency
    #
    #]]
    cpp_member(build_dependency RemoteURLDependency)
    function("${build_dependency}" _bd_this)

        RemoteURLDependency(GET "${_bd_this}" _bd_url location)
        RemoteURLDependency(GET "${_bd_this}" _bd_name name)

        RemoteURLDependency(_cache_args "${_bd_this}" _bd_old_cmake_args)

        cmaize_fetch_and_available("${_bd_name}" URL "${_bd_url}")

        RemoteURLDependency(_uncache_args "${_bd_this}" _bd_old_cmake_args)

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
    cpp_member(init RemoteURLDependency args)
    function("${init}" self)

        set(_i_options )
        set(_i_one_value_args BUILD_TARGET FIND_TARGET NAME URL)
        set(_i_list CMAKE_ARGS)
        cmake_parse_arguments(
            _i "${_i_options}" "${_i_one_value_args}" "${_i_list}" ${ARGN}
        )

        RemoteURLDependency(SET "${self}" location "${_i_URL}")

        RemoteURLDependency(SET "${self}" name "${_i_NAME}")
        RemoteURLDependency(SET "${self}" build_target "${_i_BUILD_TARGET}")
        RemoteURLDependency(SET "${self}" find_target "${_i_FIND_TARGET}")
        RemoteURLDependency(SET "${self}" cmake_args "${_i_CMAKE_ARGS}")

    endfunction()

cpp_end_class()
