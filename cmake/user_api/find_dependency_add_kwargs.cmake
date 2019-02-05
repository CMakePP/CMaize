include_guard()
include(find_recipe/factory_add_kwargs)
include(kwargs/kwargs)

function(_cpp_find_dependency_add_kwargs _cfdak_kwargs)
    _cpp_FindRecipe_factory_add_kwargs(${_cfdak_kwargs})
    _cpp_Kwargs_add_keywords(
        ${_cfdak_kwargs} TOGGLES OPTIONAL OPTIONS RESULT PATHS
    )
    _cpp_Kwargs_set_default(${_cfdak_kwargs} RESULT CPP_DEV_NULL)
endfunction()
