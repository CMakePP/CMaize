include_guard()

function(_cpp_toolchain_get _ctg_output _ctg_tc _ctg_var)
    file(READ ${_ctg_tc} _ctg_tc_contents)
    string(
        REGEX MATCH "set\\(${_ctg_var} \"([^\\)]*)\" CACHE INTERNAL \"\"\\)"
        _ctg_found "${_ctg_tc_contents}"
    )
    if(NOT _ctg_found)
        _cpp_error(
            "Toolchain: ${_ctg_tc} does not contain variable: ${_ctg_var}."
        )
    endif()
    set(${_ctg_output} "${CMAKE_MATCH_1}" PARENT_SCOPE)
endfunction()
