include_guard()
include(object/object)

## Handles ``xxx_DIR`` variable after ``find_package`` is called in config mode
#
# Annoyingly when ``find_package`` is run in config mode CMake sets ``xxx_DIR``
# to ``xxx_DIR-NOTFOUND`` if it can't find the package. This messes with us
# trying to determine if the user has set that variable. This function assumes
# the user won't maliciously install the dependency to the path
# ``/xxx_DIR-NOTFOUND`` (in which case ``xxx_DIR-NOTFOUND`` is actually the
# directory) and will reset the variable. If ``xxx_DIR`` is set to any other
# value it will remain untouched and that value will be recorded on the provided
# object.
#
# .. note::
#
#     This function should be considered a private member function of the
#     ``FindFromConfig`` class.
#
# :param handle: The handle of the object we are trying to find.
function(_cpp_FindFromConfig_handle_dir _cFhd_handle)
    _cpp_Object_get_value(${_cFhd_handle} _cFhd_name name)
    set(_cFhd_dir ${_cFhd_name}_DIR)
    set(_cFhd_value "${${_cFhd_dir}}")
    _cpp_are_equal(_cFhd_wasnt_found "${_cFhd_value}" "${_cFhd_dir}-NOTFOUND")
    if(_cFhd_wasnt_found)
        unset(${_cFhd_dir} CACHE)
    else()
        _cpp_Object_set_value(${_cFhd_handle} config_path "${_cFhd_value}")
    endif()
endfunction()
