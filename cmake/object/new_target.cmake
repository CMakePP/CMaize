include_guard()

## Assigns a target to a handle
#
# This function creates a CMake target that will store the state of an object.
# The resulting target will have a unique name and be mangled in such a way that
# it should not interfere with targets created by other CMake projects or for
# other CPP instances (barring malicious intent).
#
# :param var: The identifier to assign the handle to
# :param type: The type of the new instance
#
function(_cpp_Object_new_target _cOnt_var _cOnt_type)
    set(_cOnt_not_good TRUE)
    while(_cOnt_not_good)
        string(RANDOM _cOnt_gibberish)
        set(_cOnt_handle _cpp_${_cOnt_gibberish}_${_cOnt_type})
        _cpp_is_target(_cOnt_not_good ${_cOnt_handle})
    endwhile()
    add_library(${_cOnt_handle} INTERFACE)
    set(${_cOnt_var} ${_cOnt_handle} PARENT_SCOPE)
endfunction()

## Mangles a member name for storage as a property
#
# :param result: The computed mangled name for the member
# :param name: The name this function will mangle
function(_cpp_Object_mangle_member _cOmm_result _cOmm_name)
    string(TOLOWER ${_cOmm_name} _cOmm_lc)
    set(${_cOmm_result} _cpp_${_cOmm_lc} PARENT_SCOPE)
endfunction()

## Returns the list of all members an object possess
#
# This function is largely intended for use by other Object functions. It is
# used to retrieve the names of an object's members. It does not retrieve those
# members' values.
#
# :param result: The instance to hold the resulting list.
# :param handle: The object whose members we want.
#
function(_cpp_Object_get_members _cOgm_result _cOgm_handle)
    get_target_property(_cOgm_value ${_cOgm_handle} _cpp_Object_member_list)
    if("${_cOgm_value}" STREQUAL "_cOgm_value-NOTFOUND")
        set(${_cOgm_result} "" PARENT_SCOPE)
    else()
        set(${_cOgm_result} "${_cOgm_value}" PARENT_SCOPE)
    endif()
endfunction()

## Determines if an object has a particular member
#
# :param result: True if the object has the member and false otherwise
# :param handle: The object to search for the member
# :param member: The member to look for
#
function(_cpp_Object_has_member _cOhm_result _cOhm_handle _cOhm_member)
    _cpp_Object_get_members(_cOhm_members ${_cOhm_handle})
    _cpp_Object_mangle_member(_cOhm_member_name "${_cOhm_member}")
    list(FIND _cOhm_members ${_cOhm_member_name} _cOhm_position)
    _cpp_are_not_equal(_cOhm_present "${_cOhm_position}" "-1")
    set(${_cOhm_result} ${_cOhm_present} PARENT_SCOPE)
endfunction()

## Adds a list of members to an object
#
#  This function takes a handle to an object and arbitrary number of member
#  names (passed via ``ARGN``) and creates fields on the object for each of the
#  members.
#
# :param handle: The object to add the members to
#
function(_cpp_Object_add_members _cOam_handle)
    _cpp_Object_get_members(_cOam_members ${_cOam_handle})
    foreach(_cOam_member_i ${ARGN})
        _cpp_Object_has_member(_cOam_present ${_cOam_handle} ${_cOam_member_i})
        if(_cOam_present)
            _cpp_error(
                "Failed to add member ${_cOam_member_i}. Already present."
            )
        endif()
        _cpp_Object_mangle_member(_cOam_member_name "${_cOam_member_i}")
        list(APPEND _cOam_members ${_cOam_member_name})
        set_target_properties(
          ${_cOam_handle} PROPERTIES _cpp_Object_member_list "${_cOam_members}"
        )
        set_target_properties(
            ${_cOam_handle} PROPERTIES ${_cOam_member_name} NULL
        )
    endforeach()
endfunction()

## Convenience function for making an object with the specified members
#
#  This function simply wraps :ref:`_cpp_Object_new_target-label` and
#  :ref:`_cpp_Object_add_members`.
#
#  :param result: The handle to the newly created object
#  :param type: The type to create
function(_cpp_Object_new_object _cOno_result _cOno_type)
    _cpp_Object_new_target(_cOno_temp ${_cOno_type})
    _cpp_Object_add_members(${_cOno_temp} ${ARGN})
    set(${_cOno_result} ${_cOno_temp} PARENT_SCOPE)
endfunction()

## Sets the member of a class to a given value
#
# :param handle: The handle of the object to set
# :param member: The name of the member to set
# :param value: The value to set the member to
function(_cpp_Object_set_value _cOsv_handle _cOsv_member _cOsv_value)
    _cpp_Object_has_member(_cOsv_present ${_cOsv_handle} ${_cOsv_member})
    if(NOT ${_cOsv_present})
        _cpp_error("Object has no member ${_cOsv_member}")
    endif()
    _cpp_Object_mangle_member(_cOsv_member_name ${_cOsv_member})
    set_target_properties(
       ${_cOsv_handle} PROPERTIES ${_cOsv_member_name} ${_cOsv_value}
    )
endfunction()

## Reads the value of an instance's member
#
# :param value: An identifier to save the value to
# :param handle: The handle to the object we are reading
# :param member: The member whose value we are reading
function(_cpp_Object_get_value _cOgv_value _cOgv_handle _cOgv_member)
    _cpp_Object_has_member(_cOgv_present ${_cOgv_handle} ${_cOgv_member})
    if(NOT ${_cOgv_present})
        _cpp_error("Object has no member ${_cOgv_member}")
    endif()
    _cpp_Object_mangle_member(_cOgv_member_name ${_cOgv_member})
    get_target_property(_cOgv_temp ${_cOgv_handle} ${_cOgv_member_name})
    set(${_cOgv_value} ${_cOgv_temp} PARENT_SCOPE)
endfunction()
