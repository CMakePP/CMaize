include_guard()
include(find_recipe/ctor_add_kwargs)

##
#
# :param kwargs: A handle to the ``Kwargs`` instance we are modifying.
function(_cpp_FindFromConfig_ctor_add_kwargs _cFcak_kwargs)
    _cpp_FindRecipe_ctor_add_kwargs(${_cFcak_kwargs})
endfunction()
