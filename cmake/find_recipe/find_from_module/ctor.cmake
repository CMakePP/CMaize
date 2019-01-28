include_guard()

include(find_recipe/ctor)
include(utility/set_return)

function(_cpp_FindFromModule_ctor _cFc_handle _cFc_module _cFc_name _cFc_version
                                  _cFc_components)
    _cpp_is_empty(_cFc_module_not_set _cFc_module)
    if(_cFc_module_not_set)
        _cpp_error("Module path must be set.")
    endif()

    _cpp_FindRecipe_ctor(
        _cFc_temp "${_cFc_name}" "${_cFc_version}" "${_cFc_components}"
    )
    _cpp_Object_set_type(${_cFc_temp} FindFromModule)
    _cpp_Object_add_members(${_cFc_temp} module_path)
    _cpp_Object_set_value(${_cFc_temp} module_path ${_cFc_module})
    _cpp_set_return(${_cFc_handle} ${_cFc_temp})
endfunction()
