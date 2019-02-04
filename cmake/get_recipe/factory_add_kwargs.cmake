include_guard()
include(get_recipe/get_from_disk/ctor_add_kwargs)
include(get_recipe/get_from_url/factory_add_kwargs)

function(_cpp_GetRecipe_factory_add_kwargs _cGfak_kwargs)
    _cpp_GetFromDisk_ctor_add_kwargs(${_cGfak_kwargs})
    _cpp_GetFromURL_factory_add_kwargs(${_cGfak_kwargs})
    _cpp_Kwargs_add_keywords(${_cGfak_kwargs} OPTIONS SOURCE_DIR URL)
endfunction()
