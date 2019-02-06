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

function(cpp_add_library _cal_name)
    set(_cal_T_KWARGS STATIC)
    set(_cal_O_KWARGS CXX_STANDARD INCLUDE_DIR)
    set(_cal_M_KWARGS SOURCES INCLUDES DEPENDS)
    cmake_parse_arguments(
            _cal
            "${_cal_T_KWARGS}"
            "${_cal_O_KWARGS}"
            "${_cal_M_KWARGS}"
            ${ARGN}
    )

    _cpp_is_not_empty(_cal_has_src _cal_SOURCES)
    _cpp_is_not_empty(_cal_has_incs _cal_INCLUDES)
    _cpp_is_not_empty(_cal_has_deps _cal_DEPENDS)
    cpp_option(_cal_CXX_STANDARD 17)
    cpp_option(_cal_INCLUDE_DIR ${PROJECT_SOURCE_DIR})
    if(_cal_STATIC)
        if(_cal_has_src)
            #Static library has to have sources
            add_library(${_cal_name} STATIC ${_cal_SOURCES})
        else()
            message(FATAL_ERROR "Static libraries need source files...")
        endif()
    else()
        if(_cal_has_src) #Non-interface library
            add_library(${_cal_name} ${_cal_SOURCES})
            if(_cal_has_incs)
                set_target_properties(
                        ${_cal_name}
                        PROPERTIES PUBLIC_HEADER
                        "${_cal_INCLUDES}"
                )
                target_include_directories(
                        ${_cal_name}
                        PUBLIC
                        $<BUILD_INTERFACE:${_cal_INCLUDE_DIR}>
                        $<INSTALL_INTERFACE:include>
                )
            endif()
            target_compile_features(
                    ${_cal_name} PUBLIC "cxx_std_${_cal_CXX_STANDARD}"
            )
            if(_cal_has_deps)
                target_link_libraries(${_cal_name} ${_cal_DEPENDS})
            endif()
        else() #interface library
            add_library(${_cal_name} INTERFACE)
            target_include_directories(
                    ${_cal_name}
                    INTERFACE
                    $<BUILD_INTERFACE:${_cal_INCLUDE_DIR}>
                    $<INSTALL_INTERFACE:include>
            )
            target_compile_features(
                    ${_cal_name} INTERFACE "cxx_std_${_cal_CXX_STANDARD}"
            )
            if(_cal_has_deps)
                target_link_libraries(${_cal_name} INTERFACE ${_cal_DEPENDS})
            endif()
        endif()
    endif()
endfunction()
