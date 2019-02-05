include_guard()

function(_cpp_BuildRecipe_ctor_add_kwargs _cFcak_kwargs)
    _cpp_Kwargs_add_keywords(
        ${_cFcak_kwargs}
        OPTIONS NAME VERSION SOURCE_DIR TOOLCHAIN
        LISTS CMAKE_ARGS
    )
    _cpp_Kwargs_set_default(
       ${_cFcak_kwargs} TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}"
    )
    _cpp_Kwargs_set_default(${_cFcak_kwargs} VERSION "latest")
endfunction()
