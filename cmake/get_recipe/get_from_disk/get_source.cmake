include_guard()

## Creates a tarball of locally stored source code
#
# :param handle: The handle to the GetFromDisk object
# :param tar: The full path to where the tarball should go.
function(_cpp_GetFromDisk_get_source _cGgs_handle _cGgs_tar)
    _cpp_Object_get_value(${_cGgs_handle} _cGgs_dir dir)
    _cpp_tar_directory(${_cGgs_tar} ${_cGgs_dir})
endfunction()
