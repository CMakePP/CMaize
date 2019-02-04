include_guard()

function(_cpp_in_list _cil_return _cil_value _cil_list)
    list(FIND "${_cil_list}" "${_cil_value}" _cil_temp)
    _cpp_are_not_equal(_cil_temp "${_cil_temp}" -1)
    _cpp_set_return(${_cil_return} ${_cil_temp})
endfunction()
