include_guard()
include(object/object)

## Downloads a tarball from the internet
#
# :param handle: The handle to the GetFromURL object with the specs
# :param tar: The path to where the tarball should go.
function(_cpp_GetFromURL_get_source _cGgs_handle _cGgs_tar)
    _cpp_Object_get_value(${_cGgs_handle} _cGgs_url url)
    _cpp_download_tarball(${_cGgs_tar} ${_cGgs_url})
endfunction()
