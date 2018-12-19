include_guard()

include(target/target_get_all_properties)

## Function for returning only the whitelisted properties for interface targets
#
# This function is ripped from Stack Overflow: "How to print all the properties
# of a target in cmake.
#
# :param result: The identifier to contain the returned list.
function(_cpp_target_get_whitelist _ctgw_result)
    _cpp_target_get_all_properties(_ctgw_all_props)

    #Very long regex defining acceptable prefixes for imported targets
    set(_ctgw_re1 "^(INTERFACE|[_a-z]|IMPORTED_LIBNAME_|MAP_IMPORTED_CONFIG_)")
    set(_ctgw_re2 "|^(COMPATIBLE_INTERFACE_(BOOL|NUMBER_MAX|NUMBER_MIN|STRING)")
    set(_ctgw_re3 "|EXPORT_NAME|IMPORTED(_GLOBAL|_CONFIGURATIONS|_LIBNAME)")
    set(_ctgw_re4 "?|NAME|TYPE|NO_SYSTEM_FROM_IMPORTED)$")
    set(_ctgw_re "${_ctgw_re1}${_ctgw_re2}${_ctgw_re3}${_ctgw_re4}")

    set(_ctgw_whitelist "")
    foreach(_ctgw_prop ${_ctgw_all_props})
        if(_ctgw_prop MATCHES "${_ctgw_re}")
            list(APPEND _ctgw_whitelist ${_ctgw_prop})
        endif()
    endforeach()

    set(${_ctgw_result} "${_ctgw_whitelist}" PARENT_SCOPE)
endfunction()
