################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()
include(cache/cache_add_dependency)
include(cache/cache_build_dependency)
include(dependency/cpp_find_dependency)


## Function for building a dependency if we can not locate it.
#
# This function is the public API for users who want CPP to build a dependency
# if it can not be found.
#
# :kwargs:
#
#     * *NAME* (``option``) - The name of the dependency we are looking for.
#     * *URL* (``option``) - The URL to use to download the dependency.
#     * *BRANCH* (``option``) - The branch of the source code to use, if the
#       source code is version controlled with git.
#     * *PRIVATE* (``toggle``) - If present, specifies that the URL points to
#       a private GitHub repository. The repository will be accessed using the
#       value of ``CPP_GITHUB_TOKEN``.
#     * *SOURCE_DIR* (``option``) - Provides the path to the source code for the
#       dependency.
#     * *VERSION* (``option``) - The version of the dependency we are looking
#       for.
#     * *COMPONENTS* (``list``) - A list of components that the dependency must
#       provide.
#     * *FIND_MODULE* (``option``) - The path to a user provided find module.
#     * *TOOLCHAIN* (``option``) - The path to the toolchain file to use. By
#       default the current toolchain is used.
#     * *CPP_CACHE* (``option``) - The path to the CPP cache to use. By default
#       the current CPP cache is used.
#     * *BINARY_DIR* (``option``) - The directory to use as a build directory
#       for the dependency. Defaults to the current build directory.
#
# :CMake Variables:
#
#     * *CPP_INSTALL_CACHE* - Used as the default CPP cache. Behavior can be
#       overridden by the ``CPP_CACHE`` kwarg.
#     * *CMAKE_TOOLCHAIN_FILE* - Used as the default toolchain. Behavior can be
#       overriden by the ``TOOLCHAIN`` kwarg.
#     * *CMAKE_BINARY_DIR* - Used as the default build directory. Behavior can
#       be overridden by the ``BINARY_DIR`` kwarg.
#     * *CPP_GITHUB_TOKEN* - Used to retrieve the user's token if GitHub
#       authentication is needed.
function(cpp_find_or_build_dependency)
    cpp_parse_arguments(
        _cfobd "${ARGN}"
        TOGGLES PRIVATE
        OPTIONS NAME VERSION TOOLCHAIN CPP_CACHE FIND_MODULE BINARY_DIR
                URL BRANCH SOURCE_DIR BUILD_MODULE
        LISTS COMPONENTS CMAKE_ARGS
        MUST_SET NAME
    )
    cpp_option(_cfobd_TOOLCHAIN ${CMAKE_TOOLCHAIN_FILE})
    cpp_option(_cfobd_BINARY_DIR "${CMAKE_BINARY_DIR}")
    cpp_option(_cfobd_CPP_CACHE "${CPP_INSTALL_CACHE}")

    _cpp_cache_write_get_recipe(
        ${_cfobd_CPP_CACHE}
        ${_cfobd_NAME}
        "${_cfobd_URL}"
        "${_cfobd_PRIVATE}"
        "${_cfobd_BRANCH}"
        "${_cfobd_SOURCE_DIR}"
    )
    _cpp_cache_write_build_recipe(
        ${_cfobd_CPP_CACHE}
        ${_cfobd_NAME}
        "${_cfobd_CMAKE_ARGS}"
        "${_cfobd_BUILD_MODULE}"
    )

    _cpp_record_find("cpp_find_or_build_dependency" ${ARGN})

    set(_cfobd_src_path ${_cfobd_BINARY_DIR}/${_cfobd_NAME})
    set(_cfobd_toolchain ${_cfobd_src_path}/toolchain.cmake)
    file(READ ${_cfobd_TOOLCHAIN} _cfobd_contents)
    file(WRITE ${_cfobd_toolchain} "${_cfobd_contents}")
    _cpp_change_toolchain(
        TOOLCHAIN ${_cfobd_toolchain}
        CMAKE_ARGS "${_cfobd_CMAKE_ARGS}"
    )

    cpp_find_dependency(
        NAME ${_cfobd_NAME}
        OPTIONAL
        RESULT _cfobd_found
        VERSION "${_cfobd_VERSION}"
        COMPONENTS "${_cfobd_COMPONENTS}"
        CPP_CACHE ${_cfobd_CPP_CACHE}
        TOOLCHAIN ${_cfobd_toolchain}
        FIND_MODULE "${_cfobd_FIND_MODULE}"
    )

    if(${_cfobd_found})
        return()
    endif()

    _cpp_cache_build_dependency(
        ${_cfobd_CPP_CACHE}
        ${_cfobd_NAME}
        "${_cfobd_VERSION}"
        ${_cfobd_toolchain}
    )

    #Look again, (find-recipe better be valid now)
    cpp_find_dependency(
        NAME ${_cfobd_NAME}
        VERSION "${_cfobd_VERSION}"
        COMPONENTS "${_cfobd_COMPONENTS}"
        CPP_CACHE ${_cfobd_CPP_CACHE}
        TOOLCHAIN ${_cfobd_toolchain}
        FIND_MODULE "${_cfobd_FIND_MODULE}"
    )
endfunction()

