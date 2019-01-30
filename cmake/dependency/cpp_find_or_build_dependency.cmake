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
include(dependency/cpp_write_dependency_toolchain)

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
        LISTS COMPONENTS CMAKE_ARGS DEPENDS
        MUST_SET NAME
    )
    cpp_option(_cfobd_TOOLCHAIN ${CMAKE_TOOLCHAIN_FILE})
    cpp_option(_cfobd_BINARY_DIR "${CMAKE_BINARY_DIR}")
    cpp_option(_cfobd_CPP_CACHE "${CPP_INSTALL_CACHE}")

    #Make install path

    #First part of install path is the version of the source
    _cpp_GetRecipe_factory(_cfobd_get_recipe ${ARGN})
    _cpp_Object_get_value(${_cfobd_get_recipe} _cfobd_version version)
    set(_cfobd_name_ver "${_cfobd_NAME}/${_cfobd_version}")
    set(_cfobd_bin_root ${_cfobd_BINARY_DIR}/${_cfobd_name_ver})
    file(MAKE_DIRECTORU ${_cfobd_bin_root})
    set(_cfobd_tar ${_cfobd_bind_root}/${_cfobd_NAME}.${_cfobd_verson}.tar.gz)
    _cpp_GetRecipe_get_source(${_cfobd_get_recipe} ${_cfobd_tar})
    file(SHA1 ${_cfobd_tar} _cfobd_version_hash)
    set(
         _cfobd_install
         ${_cfobd_CPP_CACHE}/${_cfobd_name_ver}/${_cfobd_version_hash}
    )

    #Second part is the build configuration
    _cpp_untar_directory(${_cfobd_tar} ${_cfobd_bin_root}/src)
    _cpp_BuildRecipe_factory(
        _cfobd_build_recipe
        ${_cfobd_bin_root}/src
        BUILD_MODULE "${_cfobd_BUILD_MODULE}"
        TOOLCHAIN "${_cfobd_TOOLCHAIN}"
        ARGS "${_cfobd_CMAKE_ARGS}"
    )

    _cpp_BuildRecipe_hash(${_cfobd_build_recipe} _cfobd_build_hash)

    #Dant, dant, dant, dant, dant, daaaa the install path
    set(_cfobd_install "${_cfobd_install}/${_cfobd_src_hash}")

    #Look for dependency
    cpp_find_dependency(
        OPTIONAL
        NAME ${_cfobd_NAME}
        VERSION "${_cfobd_VERSION}"
        FIND_MODULE "${_cfobd_FIND_MODULE}"
        RESULT _cfobd_found
        PATHS "${_cfobd_install}"
        COMPONENTS "${_cfobd_COMPONENTS}"
    )
    if("${_cfobd_found}")
        return()
    endif()

    #Not found, build it

    message("Building ${_cfobd_NAME} from source. This may take awhile.")
    _cpp_BuildRecipe_build_dependency(${_cfobd_build_recipe} ${_cfobd_install})

    #Find the built one
    cpp_find_dependency(
        NAME ${_cfobd_NAME}
        VERSION "${_cfobd_VERSION}"
        FIND_MODULE "${_cfobd_FIND_MODULE}"
        PATHS "${_cfobd_install}"
        COMPONENTS "${_cfobd_COMPONENTS}"
    )
endfunction()

