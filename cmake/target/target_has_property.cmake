include_guard()
include(cpp_cmake_helpers)
include(target/target_get_whitelist)

## Function for determining if a target has a specific property
#
# For whatever reason CMake makes it a pain to determine if a target has a
# particular property set on it. This function wraps the process of doing that.
# More specifically this function first checks if the property is "whitelisted".
# If the property is not on the whitelist of properties it obviously can not be
# set on the target, so this function returns false. Assuming the property is
# allowed we next call CMake's ``get_target_property``. If the result is
# "NOTFOUND" it means that the property was not set, otherwise it was set.
#
# :param result: The identifier to use for the returned result.
# :param target: The name of the target to examine.
# :param prop: The property we are looking for.
function(_cpp_target_has_property _cthp_result _cthp_target _cthp_prop)
    #Worry about whether this is a whitelisted property
    get_target_property(_cthp_type ${_cthp_target} TYPE)
    if("${_cthp_type}" STREQUAL "INTERFACE_LIBRARY")
        _cpp_target_get_whitelist(_cthp_wl)
        #Use list find so we match whole elements
        list(FIND _cthp_wl "${_cthp_prop}" _cthp_is_bl)
        if("${_cthp_is_bl}" STREQUAL "-1")
            set(${_cthp_result} FALSE PARENT_SCOPE)
            return()
        endif()
    endif()

    #It's a whitelisted property (or our target doesn't have a whitelist)
    get_target_property(_cthp_has_prop ${_cthp_target} ${_cthp_prop})
    if("${_cthp_has_prop}" STREQUAL "_cthp_has_prop-NOTFOUND")
       set(${_cthp_result} FALSE PARENT_SCOPE)
    else()
        set(${_cthp_result} TRUE PARENT_SCOPE)
    endif()
endfunction()
