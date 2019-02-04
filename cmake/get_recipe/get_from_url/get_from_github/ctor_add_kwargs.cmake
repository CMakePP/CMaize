include_guard()
include(get_recipe/get_from_url/ctor_add_kwargs)

## Adds ``GetFromGitHub``'s ctor's kwargs to a ``Kwargs`` instance.
#
# :param kwargs: The ``Kwargs`` instance to populate.
function(_cpp_GetFromGitHub_ctor_add_kwargs _cGcak_kwargs)
    _cpp_GetFromURL_ctor_add_kwargs(${_cGcak_kwargs})
    _cpp_Kwargs_add_keywords(${_cGcak_kwargs} TOGGLES PRIVATE OPTIONS BRANCH)
    _cpp_Kwargs_set_default(${_cGcak_kwargs} BRANCH master)
endfunction()
