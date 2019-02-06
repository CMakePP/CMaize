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

function(cpp_add_executable _cae_name)
    set(_cae_O_KWARGS CXX_STANDARD INCLUDE_DIR)
    set(_cae_M_KWARGS SOURCES DEPENDS)
    cmake_parse_arguments(
            _cae "" "${_cae_O_KWARGS}" "${_cae_M_KWARGS}" ${ARGN}
    )
    _cpp_is_not_empty(_cae_has_src _cae_SOURCES)
    _cpp_assert_true(_cae_has_src)
    add_executable(${_cae_name} ${_cae_SOURCES})
    cpp_option(_cae_CXX_STANDARD 17)
    cpp_option(_cae_INCLUDE_DIR ${PROJECT_SOURCE_DIR})
    target_include_directories(
            ${_cae_name}
            PRIVATE $<BUILD_INTERFACE:${_cae_INCLUDE_DIR}>
            $<INSTALL_INTERFACE:include>
    )
    target_compile_features(
            ${_cae_name} PUBLIC "cxx_std_${_cae_CXX_STANDARD}"
    )
    _cpp_is_not_empty(_cae_has_deps _cae_DEPENDS)
    if(_cae_has_deps)
        target_link_libraries(${_cae_name} ${_cae_DEPENDS})
    endif()
endfunction()
