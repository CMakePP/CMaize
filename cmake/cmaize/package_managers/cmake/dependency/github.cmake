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

include(cmaize/package_managers/cmake/dependency/git)
include(cmaize/utilities/fetch_and_available)
include(cmaize/utilities/sanitize_url)

cpp_class(GitHubDependency GitDependency)

    #[[[
    # :type: bool
    #
    # Is this a private GitHub Repo (TRUE) or not (FALSE)? Defaults to FALSE.
    #]]
    cpp_attr(GitHubDependency private FALSE)

    #[[[
    # Attempts to fetch and build the dependency.
    #
    # :param self: Dependency object
    # :type self: Dependency
    #
    # :raises GitHubTokenMissing: CMAIZE_GITHUB_TOKEN variable not defined.
    #]]
    cpp_member(build_dependency GitHubDependency)
    function("${build_dependency}" _bd_this)

        GitHubDependency(GET "${_bd_this}" _bd_url location)
        GitHubDependency(GET "${_bd_this}" _bd_private private)
        GitHubDependency(GET "${_bd_this}" _bd_version version)
        GitHubDependency(GET "${_bd_this}" _bd_name name)
        GitHubDependency(GET "${_bd_this}" _bd_cmake_args cmake_args)

        # TODO: In the future, this might need to be generalized more to
        #       accommodate those who use multiple accounts with SSH keys
        #       associated with them. In these situations, the string
        #       below, "git@github.com:", would look something like
        #       "git@github-alt-account:", where the user has set up
        #       "github-alt-account" in their ~/.ssh/config file as a
        #       "Host" with a different ssh key associated with it. The
        #       REGEX MATCH below should do this, but the `cmaize_sanitize_url`
        #       function also must be redesigned for these URLs to be allowed.
        # string(REGEX MATCH "^git@[A-Za-z0-9_-]:" _bd_is_ssh "${_bd_url}")
        string(FIND "${_bd_url}" "git@github.com:" _bd_is_ssh)

        # Determine what type of URL to generate to access the repository
        if(_bd_is_ssh GREATER -1)
            message(DEBUG "Fetching GitHub repository via SSH: ${_bd_url}")
            # Don't do anything to the URL
        elseif("${_bd_private}")
            if("${CMAIZE_GITHUB_TOKEN}" STREQUAL "")
                cpp_raise(
                  GitHubTokenMissing
                  "Private GitHub repos require CMAIZE_GITHUB_TOKEN to be set."
                )
            endif()

            message(DEBUG
                "Fetching private GitHub repository using the value of "
                "CMAIZE_GITHUB_TOKEN: "
                "https://\${CMAIZE_GITHUB_TOKEN}@${_bd_url}"
            )
            set(_bd_url "https://${CMAIZE_GITHUB_TOKEN}@${_bd_url}")
        else()
            message(DEBUG
                "Fetching public GitHub repository: https://${_bd_url}"
            )
            set(_bd_url "https://${_bd_url}")
        endif()

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

        # It's possible GitHub URLs link to an "asset" (i.e., a tarball)
        string(FIND "${_bd_url}" ".tgz" _bd_is_tarball)

        if("${_bd_is_tarball}" STREQUAL "-1")
            cmaize_fetch_and_available(
                "${_bd_name}"
                GIT_REPOSITORY "${_bd_url}"
                GIT_TAG "${_bd_version}"
            )
        else()
            cmaize_fetch_and_available("${_bd_name}" URL "${_bd_url}")
        endif()

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
    #    * **VERSION** (*desc*) --
    #      Version of the target to find or build.
    #]]
    cpp_member(init GitHubDependency args)
    function("${init}" self)

        set(_i_options PRIVATE)
        set(_i_one_value_args BUILD_TARGET FIND_TARGET NAME URL VERSION)
        set(_i_list CMAKE_ARGS)
        cmake_parse_arguments(
            _i "${_i_options}" "${_i_one_value_args}" "${_i_list}" ${ARGN}
        )

        # Clean up the GitHub URL and ensure it is from GitHub
        cmaize_sanitize_url(_i_URL "${_i_URL}" DOMAIN "github.com")
        GitDependency(SET "${self}" location "${_i_URL}")

        GitHubDependency(SET "${self}" name "${_i_NAME}")
        GitHubDependency(SET "${self}" version "${_i_VERSION}")
        GitHubDependency(SET "${self}" build_target "${_i_BUILD_TARGET}")
        GitHubDependency(SET "${self}" find_target "${_i_FIND_TARGET}")

        # Set the private attribute if necessary
        Dependency(SET "${self}" private "${_i_PRIVATE}")

        Dependency(SET "${self}" cmake_args "${_i_CMAKE_ARGS}")

    endfunction()

cpp_end_class()
