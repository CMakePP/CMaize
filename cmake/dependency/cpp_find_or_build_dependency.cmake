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

function(cpp_find_or_build_dependency)
    #Get a list of all the kwargs

    foreach(_cfobd_type BUILD GET FIND)
        _cpp_recipe_kwargs(_cfobd_toggle _cfobd_opts _cfobd_list ${_cfobd_type})
        list(APPEND _cfobd_T_kwargs ${_cfobd_toggle})
        list(APPEND _cfobd_O_kwargs ${_cfobd_opts})
        list(APPEND _cfobd_L_kwargs ${_cfobd_list})
    endforeach()
    cpp_parse_arguments(
        _cfobd "${ARGN}"
        TOGGLES ${_cfobd_T_kwargs}
        OPTIONS ${_cfobd_O_kwargs}
        LISTS ${_cfobd_L_kwargs}
        MUST_SET NAME
    )
    cpp_option(_cfobd_TOOLCHAIN ${CMAKE_TOOLCHAIN_FILE})
    cpp_option(_cfobd_BINARY_DIR "${CMAKE_BINARY_DIR}")
    cpp_option(_cfobd_CPP_CACHE "${CPP_INSTALL_CACHE}")

    _cpp_cache_write_get_recipe(
        ${_cfobd_CPP_CACHE}
        ${_cfobd_NAME}
        ${_cfobd_URL}
        ${_cfobd_PRIVATE}
        ${_cfobd_BRANCH}
        ${_cfobd_SOURCE_DIR}
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
        ${_cfobd_UNPARSED_ARGUMENTS}
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
        ${_cfobd_UNPARSED_ARGUMENTS}
    )
endfunction()

