include_guard()
include(object/object)

## Class storing the information required to build a dependency
#
#
function(_cpp_BuildRecipe_ctor _cBc_handle _cBc_src _cBc_args)
    _cpp_Object_ctor(_cBc_temp)
    _cpp_Object_set_type(${_cBc_temp})
    _cpp_Object_add_members(${_cBc_temp} src args)
    _cpp_Object_set_value(${_cBc_temp} src "${_cBc_src}")
    _cpp_Object_set_value(${_cBc_temp} args "${_cBc_args}")
    _cpp_set_return(${_cBc_handle} ${_cBc_temp})
endfunction()
