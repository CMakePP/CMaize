include_guard()
include(serialization/serialize_value)
include(object/object)

## Serializes a CPP object into JSON format
#
# This function ultimately loops over every member of the object and then passes
# that element to :ref:`serialize_value-label`.
#
# :param return: An identifier to hold the returned object
# :param handle: A handle to an object
function(_cpp_serialize_object _cso_return _cso_handle)
    set(_cso_rv "{")
    set(_cso_not_1st FALSE)
    _cpp_Object_get_members(_cso_members ${_cso_handle})
    foreach(_cso_i ${_cso_members})
        if(_cso_not_1st)
            set(_cso_rv "${_cso_rv} ,")
        endif()
        _cpp_Object_get_value(_cso_value ${_cso_handle} ${_cso_i})
        _cpp_serialize_value(_cso_str "${_cso_value}")
        set(_cso_rv "${_cso_rv} \"${_cso_i}\" : ${_cso_str}")
        set(_cso_not_1st TRUE)
    endforeach()
    set(${_cso_return} "${_cso_rv} }" PARENT_SCOPE)
endfunction()
