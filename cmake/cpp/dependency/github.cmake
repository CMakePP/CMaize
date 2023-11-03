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
include(cpp/dependency/dependency_class)

cpp_class(GitHubDependency Dependency)

    ## Is this a private GitHub Repo?
    cpp_attr(GitHubDependency private FALSE)

    ## What git tag/hash should we use?
    cpp_attr(GitHubDependency version master)

    ## What is the base URL?
    cpp_attr(GitHubDependency url)

    cpp_member("${build_dependency}" GitHubDependency)
    function("${build_dependency}" _bd_this)
        GitHubDependency(GET "${_bd_this}" _bd_url url)
        GitHubDependency(GET "${_bd_this}" _bd_private private)
        GitHubDependency(GET "${_bd_this}" _bd_version version)
        GitHubDependency(GET "${_bd_this}" _bd_name name)
        GitHubDependency(GET "${_bd_this}" _bd_cmake_args cmake_args)

        # TODO: make sure URL starts with github.com/

        if("${_bd_private}")
            if("${CPP_GITHUB_TOKEN}" STREQUAL "")
                message(
                  FATAL_ERROR
                  "Private GitHub repos require CPP_GITHUB_TOKEN to be set."
                )
            endif()
            set(_bd_url "https://${CPP_GITHUB_TOKEN}@${_bd_url}")
        else()
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
            cpp_fetch_and_available(
                "${_bd_name}"
                GIT_REPOSITORY "${_bd_url}"
                GIT_TAG "${_bd_version}"
            )
        else()
            cpp_fetch_and_available("${_bd_name}" URL "${_bd_url}")
        endif()

        foreach(_bd_pair ${_bd_old_cmake_args})
            string(REPLACE "=" [[;]] _bd_split_pair "${_bd_pair}")
            list(GET _bd_split_pair 0 _bd_var)
            list(GET _bd_split_pair 1 _bd_val)
            set("${_bd_var}" "${_bd_val}" CACHE BOOL "" FORCE)
        endforeach()

        _cpp_dependency_check_target("${_bd_this}" "build")
        # It's now "found" since it's been added to our build system
        Dependency(SET "${_bd_this}" found TRUE)
    endfunction()

    cpp_member(init GitHubDependency args)
    function("${init}" _i_this)
        set(_i_flags PRIVATE)
        set(_i_options BUILD_TARGET FIND_TARGET NAME URL VERSION)
        set(_i_list CMAKE_ARGS)
        cmake_parse_arguments(
            _i "${_i_flags}" "${_i_options}" "${_i_list}" ${ARGN}
        )

        if("${_i_PRIVATE}")
            Dependency(SET "${_i_this}" private TRUE)
        endif()

        foreach(_i_option_i ${_i_options})
            if("${_i_${_i_option_i}}" STREQUAL "")
                continue()
            endif()
            string(TOLOWER "${_i_option_i}" _i_lc_option_i)
            Dependency(
               SET "${_i_this}" "${_i_lc_option_i}" "${_i_${_i_option_i}}"
            )
        endforeach()

        if(NOT "${_i_CMAKE_ARGS}" STREQUAL "")
            Dependency(
                SET "${_i_this}" cmake_args "${_i_CMAKE_ARGS}"
            )
        endif()
    endfunction()
cpp_end_class()
