include_guard()
include(get_recipe/ctor_add_kwargs)

## Adds ``GetFromDisk``'s kwargs to a ``Kwargs`` instance
#
# :param kwargs: A handle to the ``Kwargs`` instance we are modifying.
function(_cpp_GetFromDisk_ctor_add_kwargs _cGcak_kwargs)
    _cpp_GetRecipe_ctor_add_kwargs(${_cGcak_kwargs})
endfunction()
