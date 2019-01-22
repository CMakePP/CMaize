include_guard()
include(logic/has_property)
include(logic/negate)

## Determines if a target has a property set to a non-empty value
#
# This function works by negating :ref:`cpp_has_property-label`.
#
# :param return: The identifier to hold the returned value.
# :param target: The target we are checking.
# :param member: The member we are looking for
function(_cpp_does_not_have_property _cdnhp_return _cdnhp_target _cdnhp_member)
    _cpp_has(_cdnhp_temp "${_cdnhp_target}" "${_cdnhp_member}")
    _cpp_negate(_cdnhp_temp ${_cdnhp_temp})
    set(${_cdnhp_return} ${_cdnhp_temp} PARENT_SCOPE)
endfunction()
