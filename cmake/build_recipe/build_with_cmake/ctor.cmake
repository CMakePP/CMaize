include_guard()

include(build_recipe/ctor)
include(utility/set_return)

function(_cpp_BuildWithCMake_ctor _cBc_handle _cBc_src _cBc_tc _cBc_args)
    _cpp_BuildRecipe_ctor(_cBc_temp "${_cBc_src}" "${_cBc_tc}" "${_cBc_args}")
    _cpp_Object_set_type(${_cBc_temp} BuildWithCMake)
    _cpp_set_return(${_cBc_handle} ${_cBc_temp})
endfunction()
