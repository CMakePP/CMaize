include_guard()

include(find_recipe/ctor_add_kwargs)

##
#
# :param kwargs: The ``Kwargs`` instance we are modifiying.
function(_cpp_FindFromModule_ctor_add_kwargs _cFcak_kwargs)
    _cpp_FindRecipe_ctor_add_kwargs(${_cFcak_kwargs})
endfunction()
