include_guard()

include(build_recipe/ctor)
include(utility/set_return)

function(_cpp_BuildWithModule_ctor _cBc_handle _cBc_module _cBc_src _cBc_tc
                                   _cBc_args)
    _cpp_does_not_exist(_cBc_dne "${_cBc_module}")
    if(_cBc_dne)
        _cpp_error("Build module: ${_cBc_module} does not exist.")
    endif()

    _cpp_BuildRecipe_ctor(_cBc_temp "${_cBc_src}" "${_cBc_tc}" "${_cBc_args}")
    _cpp_Object_set_type(${_cBc_temp} BuildWithModule)
    _cpp_Object_add_members(${_cBc_temp} module_path)
    _cpp_Object_set_value(${_cBc_temp} module_path ${_cBc_module})
    _cpp_set_return(${_cBc_handle} ${_cBc_temp})
endfunction()
