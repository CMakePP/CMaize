include_guard()
include(logic/in_list)
include(logic/negate)
include(utility/set_return)

function(_cpp_not_in_list _cnil_return _cnil_value _cnil_list)
    _cpp_in_list(_cnil_temp "${_cnil_value}" "${_cnil_list}")
    _cpp_negate(_cnil_temp "${_cnil_temp}")
    _cpp_set_return(${_cnil_return} ${_cnil_temp})
endfunction()
