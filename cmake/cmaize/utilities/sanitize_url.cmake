include_guard()
include(cmakepp_lang/cmakepp_lang)

#[[[
# Sanitizes and checks a URL.
#
# This function removes any preceeding scheme identifier (https://) and
# optionally ensures that the given website domain is contained in the
# URL.
#
# :param __su_result: Return variable for sanitized URL.
# :type __su_result: desc
# :param __su_url: URL to sanitize.
# :type __su_url: desc
#
# :Keyword Arguments:
#    * **DOMAIN** (*desc*) --
#      Domain of the URL. It will be verified that this domain is
#      contained in the URL.
#
# :raises InvalidURL: URL is invalid.
#]]
function(cmaize_sanitize_url __su_result __su_url)

    set(__su_flags "")
    set(__su_options DOMAIN) # Fully qualified domain name
    set(__su_list "")
    cmake_parse_arguments(
        __su "${__su_flags}" "${__su_options}" "${__su_list}" ${ARGN}
    )

    # Create a temporary copy for modification
    set(__su_tmp_url "${__su_url}")

    # Remove scheme like https:// or http:// from the URL
    string(FIND "${__su_tmp_url}" "://" __su_scheme_loc)
    if(NOT __su_scheme_loc EQUAL -1)
        MATH(EXPR __su_scheme_end "${__su_scheme_loc} + 3")
        string(SUBSTRING "${__su_tmp_url}" 0 "${__su_scheme_end}" __su_scheme)
        string(REPLACE "${__su_scheme}" "" __su_tmp_url "${__su_tmp_url}")
    endif()

    # Add a "/" to the end of the DOMAIN if it does not already have it
    string(FIND "${__su_DOMAIN}" "/" __su_slash_idx)
    string(LENGTH "${__su_DOMAIN}" __su_DOMAIN_len)
    MATH(EXPR __su_DOMAIN_len "${__su_DOMAIN_len} - 1")
    if(NOT __su_slash_idx EQUAL __su_DOMAIN_len)
        set(__su_DOMAIN "${__su_DOMAIN}/")
    endif()

    # Search for "DOMAIN/" in the URL
    string(FIND "${__su_tmp_url}" "${__su_DOMAIN}" __su_domain_found)

    # Exit early if "DOMAIN/" was not found in the URL
    if (__su_domain_found EQUAL -1)
        cpp_raise(
            InvalidURL
            "Hostname, ${__su_DOMAIN}, not found in URL: ${__su_url}"
        )
    endif()

    # I don't think DOMAIN needs to be at the exact start of the URL.
    # This allows cases like DOMAIN=github.com/ and the user provides
    # "www.github.com", which should still be valid
    # # Verify that the start of the URL is "DOMAIN/"
    # if (NOT __su_domain_found EQUAL 0)
    #     cpp_raise(
    #         InvalidURL "Invalid GitHub URL was provided: ${__su_url}"
    #     )
    # endif()

    set("${__su_result}" "${__su_tmp_url}")
    cpp_return("${__su_result}")

endfunction()