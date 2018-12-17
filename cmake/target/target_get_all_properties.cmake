include_guard()

## Function for returning all of the possible properties a target may have.
#
# This function is ripped from Stack Overflow: "How to print all the properties
# of a target in cmake.
#
# .. note::
#
#     The resulting list contains some properties that are blacklisted for
#     interface targets. See :ref:`cpp_target_get_whitelist-label` for getting
#     only the whitelisted properties.
#
# :param result: The identifier to hold the returned list.
function(_cpp_target_get_all_properties _ctgap_result)
    execute_process(
        COMMAND ${CMAKE_COMMAND} --help-property-list
        OUTPUT_VARIABLE _ctgap_temp_list
    )
    string(REGEX REPLACE ";" "\\\\;" _ctgap_temp_list "${_ctgap_temp_list}")
    string(REGEX REPLACE "\n" ";" _ctgap_temp_list "${_ctgap_temp_list}")
    # Fix Stack Overflow: How can I remove the the location property may not be
    # read from target error i
    list(
        FILTER _ctgap_temp_list EXCLUDE REGEX "^LOCATION$|^LOCATION_|_LOCATION$"
    )
    list(REMOVE_DUPLICATES _ctgap_temp_list)
    set(${_ctgap_result} "${_ctgap_temp_list}" PARENT_SCOPE)
endfunction()
