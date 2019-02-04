include_guard()
include(get_recipe/ctor_add_kwargs)

## Adds ``GetFromURL``'s kwargs to a ``Kwargs`` instance.
#
# :param kwargs: A handle to the kwargs instance.
function(_cpp_GetFromURL_ctor_add_kwargs _cGcak_kwargs)
    _cpp_GetRecipe_ctor_add_kwargs(${_cGcak_kwargs})
endfunction()
