include_guard()
include(get_recipe/ctor)
include(utility/set_return)

## A GetRecipe capable of retreiving source code from disk
#
# This class extends the GetRecipe class by adding a member ``dir`` that stores
# the path to the source code.
#
# :param handle: An identifier to store the handle for the created object.
# :param path: The path to the source code
# :param version: The version of the source code the path points to.
function(_cpp_GetFromDisk_ctor _cGc_handle _cGc_path _cGc_version)
    _cpp_is_empty(_cGc_path_not_set _cGc_path)
    if(_cGc_path_not_set)
        _cpp_error("Path can not be empty.")
    endif()

    _cpp_GetRecipe_ctor(_cGc_temp "${_cGc_version}")
    _cpp_Object_set_type(${_cGc_temp} GetFromDisk)
    _cpp_Object_add_members(${_cGc_temp} dir)
    _cpp_Object_set_value(${_cGc_temp} dir "${_cGc_path}")
    _cpp_set_return(${_cGc_handle} ${_cGc_temp})
endfunction()
