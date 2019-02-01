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

include(build_recipe/build_with_cmake/ctor)
include(build_recipe/build_with_module/ctor)

function(_cpp_BuildRecipe_factory _cBf_handle _cBf_src)
    set(_cBf_O_kwargs NAME VERSION BUILD_MODULE TOOLCHAIN ARGS)
    cmake_parse_arguments(_cBf "" "${_cBf_O_kwargs}" "" ${ARGN})
    cpp_option(_cBf_TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}")
    _cpp_is_not_empty(_cBf_module _cBf_BUILD_MODULE)
    _cpp_exists(_cBf_has_lists "${_cBf_src}/CMakeLists.txt")
    _cpp_exists(_cBf_has_conf  "${_cBf_src}/configure")
    if(_cBf_module)
        _cpp_BuildWithModule_ctor(
            _cBf_temp
            "${_cBf_BUILD_MODULE}"
            "${_cBf_NAME}"
            "${_cBf_VERSION}"
            "${_cBf_src}"
            "${_cBf_TOOLCHAIN}"
            "${_cBf_ARGS}"
        )
    elseif(_cBf_has_lists)
        _cpp_BuildWithCMake_ctor(
           _cBf_temp
           "${_cBf_NAME}"
           "${_cBf_VERSION}"
           "${_cBf_src}"
           "${_cBf_TOOLCHAIN}"
           "${_cBf_ARGS}"
        )
    elseif(_cBf_has_conf)
        _cpp_error("Autotools is not enabled yet")
        _cpp_BuildWithAutotools_ctor(_cBf_temp "${_cBf_src}" "${_cBf_ARGS}")
    else()
        _cpp_error("Not sure how to build dependency.")
    endif()
    _cpp_set_return(${_cBf_handle} ${_cBf_temp})
endfunction()
