include_guard()
include(find_recipe/find_from_config/ctor_add_kwargs)
include(find_recipe/find_from_module/ctor_add_kwargs)

function(_cpp_FindRecipe_factory_add_kwargs _cFfak_kwargs)
    _cpp_FindFromConfig_ctor_add_kwargs(${_cFfak_kwargs})
    _cpp_FindFromModule_ctor_add_kwargs(${_cFfak_kwargs})
    _cpp_Kwargs_add_keywords(${_cFfak_kwargs} OPTIONS FIND_MODULE)
endfunction()
