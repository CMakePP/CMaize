include_guard()
include(cache/add_dependency)
include(logic/is_empty)
include(utility/assert_no_extra_args)
include(utility/mkdir_if_dne)
include(utility/set_return)


## Adds a cache entry for a particular version of a dependency
#
# This function extends :ref:`cpp_Cache_add_dependency-label` to differentiate
# between developer supplied versions, *e.g.*, 1.0, 1.1, *etc.*.
#
# :param handle: A handle to the Cache instance to use.
# :param path: An identifier which will contain the path to this dependency.
# :param name: The name of the dependency.
# :param ver: The version of the dependency.
function(_cpp_Cache_add_version _cCav_handle _cCav_path _cCav_name _cCav_ver)
    _cpp_assert_no_extra_args("${ARGN}")
    _cpp_is_empty(_cCav_empty _cCav_ver)
    if(_cCav_empty)
        _cpp_error("Version can not be empty.")
    endif()

    _cpp_Cache_add_dependency(${_cCav_handle} _cCav_root "${_cCav_name}")
    set(_cCav_temp ${_cCav_root}/${_cCav_ver})
    _cpp_mkdir_if_dne(${_cCav_temp})
    _cpp_set_return(${_cCav_path} ${_cCav_temp})
endfunction()
