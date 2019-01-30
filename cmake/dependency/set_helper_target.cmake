include_guard()

## Saves a FindRecipe to a helper target
#
# This function primarily exists to decouple us from the details of the helper
# target used to pass the FindRecipe from ``cpp_find_dependency`` to
# ``cpp_install``.
#
# :param name: The name of the dependency we are associating with the object.
# :param handle: The handle of the FindRecipe to save.
function(_cpp_set_helper_target _csht_name _csht_handle)
    set(_csht_target _cpp_${_csht_name}_helper)
    add_library(${_csht_target} INTERFACE)
    set_target_properties(
        ${_csht_target} PROPERTIES _cpp_object ${_csht_handle}
    )
endfunction()
