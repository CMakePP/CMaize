include_guard()

function(_cpp_toolchain_contains _ctg_output _ctg_tc _ctg_var)
    file(READ ${_ctg_tc} _ctg_tc_contents)
    _cpp_contains(_ctg_temp "${_ctg_var}" "${_ctg_tc_contents}")
    set(${_ctg_output} ${_ctg_temp} PARENT_SCOPE)
endfunction()
