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
include(cache/cache)
include(get_recipe/get_recipe)
include(build_recipe/build_recipe)

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
    _cpp_Kwargs_ctor(
        _cfobd_kwargs "${ARGN}"
        TOGGLES PRIVATE
        OPTIONS NAME VERSION TOOLCHAIN CPP_CACHE FIND_MODULE BINARY_DIR
                URL BRANCH SOURCE_DIR BUILD_MODULE
        LISTS COMPONENTS CMAKE_ARGS DEPENDS
        MUST_SET NAME
    )
    _cpp_Kwargs_set_default(${_cfobd_kwargs} TOOLCHAIN ${CMAKE_TOOLCHAIN_FILE})
    _cpp_Kwargs_kwarg_value(${_cfobd_kwargs} _cfobd_TOOLCHAIN TOOLCHAIN)
    _cpp_Kwargs_set_default(${_cfobd_kwargs} BINARY_DIR ${CMAKE_BINARY_DIR})
    _cpp_Kwargs_kwarg_value(${_cfobd_kwargs} _cfobd_BINARY_DIR BINARY_DIR)
    _cpp_Kwargs_set_default(${_cfobd_kwargs} CPP_CACHE ${CPP_INSTALL_CACHE})
    _cpp_Kwargs_kwarg_value(${_cfobd_kwargs} _cfobd_CPP_CACHE CPP_CACHE)

    _cpp_Cache_ctor(_cfobd_cache ${_cfobd_CPP_CACHE})
    _cpp_GetRecipe_factory(_cfobd_get_recipe ${ARGN})
    _cpp_Cache_save_source(${_cfobd_cache} _cfobd_src ${_cfobd_get_recipe})

    _cpp_Kwargs_kwarg_value(${_cfobd_kwargs} _cfobd_NAME NAME)
    _cpp_Kwargs_kwarg_value(${_cfobd_kwargs} _cfobd_VERSION VERSION)
    _cpp_Kwargs_kwarg_value(${_cfobd_kwargs} _cfobd_BUILD_MODULE BUILD_MODULE)
    _cpp_Kwargs_kwarg_value(${_cfobd_kwargs} _cfobd_CMAKE_ARGS CMAKE_ARGS)

    _cpp_BuildRecipe_factory(
        _cfobd_build_recipe
        ${_cfobd_src}
        NAME "${_cfobd_NAME}"
        VERSION "${_cfobd_VERSION}"
        BUILD_MODULE "${_cfobd_BUILD_MODULE}"
        TOOLCHAIN "${_cfobd_TOOLCHAIN}"
        ARGS "${_cfobd_CMAKE_ARGS}"
    )

    _cpp_Cache_install_dir(
       ${_cfobd_cache}
       _cfobd_install
       ${_cfobd_get_recipe}
       ${_cfobd_build_recipe}
    )
    _cpp_Kwargs_kwarg_value(${_cfobd_kwargs} _cfobd_FIND_MODULE FIND_MODULE)
    _cpp_Kwargs_kwarg_value(${_cfobd_kwargs} _cfobd_COMPONENTS COMPONENTS)

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

