include_guard()

include(get_recipe/get_from_url/ctor_add_kwargs)
include(get_recipe/get_from_url/get_from_github/ctor_add_kwargs)

## Adds the kwargs needed by the ``GetFromURL`` factory function
#
# :param kwargs: A handle to the instance we are adding the kwargs to.
function(_cpp_GetFromURL_factory_add_kwargs _cGfak_kwargs)
    _cpp_GetFromURL_ctor_add_kwargs(${_cGfak_kwargs})
    _cpp_GetFromGitHub_ctor_add_kwargs(${_cGfak_kwargs})
endfunction()
