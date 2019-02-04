include_guard()
include(kwargs/kwargs)

## Declares and initializes the kwargs used by GetRecipe class
#
# :param kwargs: The ``Kwargs`` instance to add the keywords to
#
#
function(_cpp_GetRecipe_ctor_add_kwargs _cGcak_kwargs)
    _cpp_Kwargs_add_keywords(${_cGcak_kwargs} OPTIONS NAME VERSION)
    _cpp_Kwargs_set_default(${_cGcak_kwargs} VERSION "latest")
endfunction()
