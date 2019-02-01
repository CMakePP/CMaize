include_guard()
include(cache/add_version)
include(cache/save_tarball)
include(object/object)
include(utility/assert_no_extra_args)
include(utility/set_return)

## Uses a GetRecipe to save the source for a dependency to the Cache
#
# :param handle: A handle to the Cache instance to use.
# :param path: An identifier to store the source's path in
# :param get_recipe: A handle to the GetRecipe instance to use.
function(_cpp_Cache_save_source _cCss_handle _cCss_path _cCss_get_recipe)
    _cpp_assert_no_extra_args("${ARGN}")

    _cpp_Object_get_value(${_cCss_get_recipe} _cCss_name name)
    _cpp_Object_get_value(${_cCss_get_recipe} _cCss_version version)
    _cpp_Cache_add_version(
        ${_cCss_handle} _cCss_root ${_cCss_name} ${_cCss_version}
    )
    _cpp_Cache_save_tarball(${_cCss_handle} _cCss_tar ${_cCss_get_recipe})
    file(SHA1 "${_cCss_tar}" _cCss_hash)
    set(_cCss_src_dir ${_cCss_root}/src/${_cCss_hash})
    _cpp_untar_directory(${_cCss_tar} ${_cCss_src_dir})
    _cpp_set_return(${_cCss_path} ${_cCss_src_dir})
endfunction()
