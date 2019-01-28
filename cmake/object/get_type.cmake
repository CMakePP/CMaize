include_guard()

## Returns the most derived type of the object
#
# :param handle: The handle of the object we want the type of.
# :param return: An identifier to store the object's type in.
function(_cpp_Object_get_type _cOgt_handle _cOgt_return)
    _cpp_Object_get_value(${_cOgt_handle} _cOgt_temp _cpp_type)
    list(LENGTH _cOgt_temp _cOgt_length)
    math(EXPR _cOgt_i "${_cOgt_length} - 1")
    list(GET _cOgt_temp ${_cOgt_i} _cOgt_rv)
    _cpp_set_return(${_cOgt_return} ${_cOgt_rv})
endfunction()
