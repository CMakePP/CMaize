include_guard()
include(logic/is_target)
include(utility/set_return)

## Checks for the helper target that will exist if dependency was already found
#
#  The helper target allows us to grab the FindRecipe object during
#  ``cpp_install``. This function wraps the logic required to see if it exists
#  so that other functions can remain decoupled from the target.
#
# :param return: An identifier to store the result of whether the target exists.
function(_cpp_helper_target_made _chtm_return _chtm_name)
    _cpp_is_target(_chtm_been_found _cpp_${_chtm_name}_helper)
    _cpp_set_return(${_chtm_return} ${_chtm_been_found})
endfunction()
