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

function(_cpp_record_find _crf_cmd)
    set(_crf_T_kwargs OPTIONAL PRIVATE)
    set(_crf_O_kwargs NAME VERSION BRANCH SOURCE_DIR URL FIND_MODULE
        BUILD_MODULE)
    set(_crf_M_kwargs COMPONENTS CMAKE_ARGS VIRTUAL)
    cpp_parse_arguments(
        _crf "${ARGN}"
        TOGGLES ${_crf_T_kwargs}
        OPTIONS ${_crf_O_kwargs}
        LISTS ${_crf_M_kwargs}
        MUST_SET NAME
    )
    set(_crf_target _cpp_${_crf_NAME}_External)

    if(TARGET ${_crf_target})
        return() #Just do nothing we're nesting find_ calls
    endif()

    set(_crf_command "${_crf_cmd}(\n")
    foreach(_crf_T_kwarg_i ${_crf_T_kwargs})
        if(_crf_${_crf_T_kwarg_i})
            set(_crf_command "${_crf_command}    ${_crf_T_kwarg_i}\n")
        endif()
    endforeach()
    foreach(_crf_O_kwarg_i ${_crf_O_kwargs})
        _cpp_is_not_empty(_crf_set _crf_${_crf_O_kwarg_i})
        if(_crf_set)
            set(
                    _crf_command
                    "${_crf_command}    ${_crf_O_kwarg_i} ${_crf_${_crf_O_kwarg_i}}\n"
            )
        endif()
    endforeach()
    foreach(_crf_M_kwarg_i ${_crf_M_kwargs})
        _cpp_is_not_empty(_crf_set _crf_${_crf_M_kwarg_i})
        if(_crf_set)
            set(_crf_command "${_crf_command}    ${_crf_M_kwarg_i} ")
            foreach(_crf_value_i ${_crf_${_crf_M_kwarg_i}})
                set(_crf_command "${_crf_command}${_crf_value_i} ")
            endforeach()
            set(_crf_command "${_crf_command}\n")
        endif()
    endforeach()
    #Add the CPP cache
    set(_crf_command "${_crf_command}    CPP_CACHE ${CPP_INSTALL_CACHE}\n)")
    add_library(_cpp_${_crf_NAME}_External INTERFACE)
    set_target_properties(
            _cpp_${_crf_NAME}_External
            PROPERTIES INTERFACE_VERSION "${_crf_command}"
    )
endfunction()
