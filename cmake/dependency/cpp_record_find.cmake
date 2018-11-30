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
    set(_crf_command "${_crf_command})")
    add_library(_cpp_${_crf_NAME}_External INTERFACE)
    set_target_properties(
            _cpp_${_crf_NAME}_External
            PROPERTIES INTERFACE_VERSION "${_crf_command}"
    )
endfunction()
