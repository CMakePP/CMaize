include_guard()
include(object/impl/mangle_function_name)
include(logic/does_not_exist)
include(object/add_members)
include(object/get_type)
include(object/has_member)
include(object/set_value)

## Adds a member function to a class.
#
# For the moment this function assumes that your files are setup in such a
# manner that functions for your class are defined in a file ``${NAME}.cmake``
# that resides next to the file you are calling this function from. For example,
# if you call this function from ``/home/ctor.cmake`` and are adding a function
# named ``fxn`` it should reside in a file named ``/home/fxn.cmake``.
#
# The function you add must be new, *i.e.*, it can not exist already, it must
# have a valid name.
#
# :param handle: The handle of the object we are adding the function to.
# :param name: The name of the function.
# :param returns: A list of identifiers to treat as returned values
function(_cpp_Object_add_function _cOaf_handle _cOaf_name _cOaf_returns)
    _cpp_is_empty(_cOaf_empty _cOaf_name)
    if(_cOaf_empty)
        _cpp_error("Name shouldn't be empty")
    endif()
    _cpp_Object_get_type(${_cOaf_handle} _cOaf_type)
    _cpp_mangle_function_name(_cOaf_mn ${_cOaf_type} ${_cOaf_name})
    _cpp_Object_has_member(${_cOaf_handle} _cOaf_has_mem ${_cOaf_mn})
    if(_cOaf_has_mem)
        _cpp_error("Function already exists")
    endif()
    set(_cOaf_file ${CMAKE_CURRENT_SOURCE_DIR}/${_cOaf_name}.cmake)
    _cpp_does_not_exist(_cOaf_dne ${_cOaf_file})
    if(_cOaf_dne)
        _cpp_error("File ${_cOaf_file} does not exist.")
    endif()

    _cpp_Object_add_members(${_cOaf_handle} ${_cOaf_mn})
    _cpp_Object_set_value(${_cOaf_handle} ${_cOaf_mn} ${_cOaf_file})
    _cpp_Object_add_members(${_cOaf_handle} ${_cOaf_mn}_returns)
    _cpp_Object_set_value(
        ${_cOaf_handle} ${_cOaf_mn}_returns "${_cOaf_returns}"
    )
endfunction()
