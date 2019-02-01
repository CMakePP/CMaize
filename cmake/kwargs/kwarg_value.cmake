include_guard()
include(object/object)
include(utility/set_return)

## Wraps the name mangling of the kwarg keys
#
# :param handle: The handle to the Kwargs instance
# :param return: An identifier to store the results
# :param key: The key we want the value for.
function(_cpp_Kwargs_kwarg_value _cKkv_handle _cKkv_return _cKkv_key)
    _cpp_Object_get_value(${_cKkv_handle} _cKkv_temp kwargs_${_cKkv_key})
    _cpp_set_return(${_cKkv_return} "${_cKkv_temp}")
endfunction()
