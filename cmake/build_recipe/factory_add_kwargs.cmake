include_guard()
include(build_recipe/ctor_add_kwargs)
include(kwargs/kwargs)

function(_cpp_BuildRecipe_factory_add_kwargs _cBfak_kwargs)
    _cpp_BuildRecipe_ctor_add_kwargs(${_cBfak_kwargs})
    _cpp_Kwargs_add_keywords(${_cBfak_kwargs} OPTIONS BUILD_MODULE)
endfunction()
