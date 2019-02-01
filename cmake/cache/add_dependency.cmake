include_guard()
include(object/object)
include(utility/assert_no_extra_args)
include(utility/mkdir_if_dne)
include(utility/set_return)

## Makes a cache entry (directory) for a dependency
#
# :param handle: A handle to the Cache object.
# :param path: An identifier that will contain the path to the root of the
#              dependency's cache entry.
# :param name: The name of the dependency.
function(_cpp_Cache_add_dependency _cCad_handle _cCad_path _cCad_name)
    _cpp_assert_no_extra_args("${ARGN}")
    _cpp_is_empty(_cCad_empty _cCad_name)
    if(_cCad_empty)
        _cpp_error("Name of dependency can not be empty.")
    endif()

    _cpp_Object_get_value(${_cCad_handle} _cCad_root root)
    set(_cCad_depend_root ${_cCad_root}/${_cCad_name})
    _cpp_mkdir_if_dne(${_cCad_depend_root})
    _cpp_set_return(${_cCad_path} "${_cCad_depend_root}")
endfunction()
