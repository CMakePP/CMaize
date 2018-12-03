include_guard()

function(_cpp_sanitize_version _csv_output _csv_version)
    _cpp_is_empty(_csv_no_version _csv_version)
    if(_csv_no_version)
        set(${_csv_output} "" PARENT_SCOPE)
        return()
    endif()

    string(REGEX MATCH "v(.*)" _csv_start_w_v "${_csv_version}")
    _cpp_debug_print("Found v in ${_csv_version} = ${_csv_start_w_v}.")
    if(_csv_start_w_v)
        set(_csv_temp "${CMAKE_MATCH_1}")
    else()
        set(_csv_temp "${_csv_version}")
    endif()

    set(${_csv_output} ${_csv_temp} PARENT_SCOPE)
endfunction()
