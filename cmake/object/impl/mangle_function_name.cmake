include_guard()
include(utility/set_return)

## Provides a unique identifier for a function
#
#  Our member functions work similar to C++. Basically we create a function name
#  by mangling the type of the object and the function's name together.
#
# :param out: The identifier to hold the mangled name
# :param type: The type of the object getting the function
# :param name: The name of the function.
function(_cpp_mangle_function_name _cOmfn_out _cOmfn_type _cOmfn_name)
    _cpp_set_return(${_cOmfn_out} _cpp_${_cOmfn_type}_${_cOmfn_name})
endfunction()
