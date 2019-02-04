include_guard()
include(kwargs/kwargs)

function(_cpp_FindRecipe_ctor_add_kwargs _cFcak_kwargs)
    _cpp_Kwargs_add_keywords(
        ${_cFcak_kwargs}
        OPTIONS NAME VERSION
        LISTS COMPONENTS
    )
endfunction()
