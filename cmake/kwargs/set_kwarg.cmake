include_guard()
include(object/set_value)

function(_cpp_Kwargs_set_kwarg _cKsk_handle _cKsk_key _cKsk_value)
    set(_cKsk_member kwargs_${_cKsk_key})
    _cpp_Object_set_value(${_cKsk_handle} ${_cKsk_member} "${_cKsk_value}")
endfunction()
