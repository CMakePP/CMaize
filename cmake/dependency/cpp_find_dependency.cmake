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
include(dependency/cpp_special_find)
include(dependency/cpp_find_package)
include(dependency/cpp_record_find)
include(cache/cache_paths)
include(cache/cache_add_dependency)




## Function for finding a dependency.
#
# This function is the public API for users who want CPP to find a dependency
# that the end-user is responsible for building (*i.e.*, this function is the
# public API for finding a dependency that CPP can not build). This function is
# also used internally in :ref:`cpp_find_or_build_dependency` to handle the
# "finding" part.
function(cpp_find_dependency)
    cpp_parse_arguments(
            _cfd "${ARGN}"
            TOGGLES OPTIONAL
            OPTIONS
            LISTS COMPONENTS
            MUST_SET NAME
    )
    cpp_option(_cfd_RESULT CPP_DEV_NULL)
    cpp_option(_cfd_CPP_CACHE ${CPP_INSTALL_CACHE})
    cpp_option(_cfd_TOOLCHAIN ${CMAKE_TOOLCHAIN_FILE})

    if(_cfd_OPTIONAL)
        set(_cfd_optional "OPTIONAL")
    endif()

    _cpp_record_find(
        "cpp_find_dependency"
        NAME "${_cfd_NAME}"
        VERSION "${_cfd_VERSION}"
        COMPONENTS "${_cfd_COMPONENTS}"
        ${_cfd_optional}
    )

    _cpp_cache_write_find_recipe(${_cfd_CPP_CACHE} ${_cfd_NAME} ${ARGN})

    #Honor special variables
    _cpp_special_find(
        _cfd_found
        ${_cfd_CPP_CACHE}
        ${_cfd_NAME}
        "${_cfd_VERSION}"
        "${_cfd_COMPONENTS}"
    )

    if(${_cfd_found})
        set(${_cfd_RESULT} TRUE PARENT_SCOPE)
        return()
    endif()

    _cpp_cache_install_path(
        _cfd_path ${_cfd_CPP_CACHE} ${_cfd_NAME} "${_cfd_VERSION}"
        "${_cfd_TOOLCHAIN}"
    )

    _cpp_find_package(
        _cfd_found
        ${_cfd_CPP_CACHE}
        ${_cfd_NAME}
        "${_cfd_VERSION}"
        "${_cfd_COMPONENTS}"
        "${_cfd_path}"
    )
    if(${_cfd_found} OR ${_cfd_OPTIONAL})
        set(${_cfd_RESULT} ${_cfd_found} PARENT_SCOPE)
        return()
    endif()

    _cpp_error(
        "Could not locate ${_cfd_NAME}. "
        "Troubleshooting: Is the path to ${_cfd_NAME} in CMAKE_PREFIX_PATH?"
        "   (current value of CMAKE_PREFIX_PATH is: ${CMAKE_PREFIX_PATH})"
    )

endfunction()
