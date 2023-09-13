# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
# :param **kwargs: Additional keyword arguments may be necessary.
#
# :Keyword Arguments:
#    * **DOMAIN** (*desc*) --
#      Domain of the URL. It will be verified that this domain is
#      contained in the URL.
#
# :raises InvalidURL: URL is invalid.
#
# :returns: The sanitized URL.
# :rtype: desc
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

    # Remove scheme identifiers like https:// or http:// from the URL
    string(FIND "${__su_tmp_url}" "://" __su_scheme_loc)
    if(NOT __su_scheme_loc EQUAL -1)
        MATH(EXPR __su_scheme_end "${__su_scheme_loc} + 3")
        string(SUBSTRING "${__su_tmp_url}" 0 "${__su_scheme_end}" __su_scheme)
        string(REPLACE "${__su_scheme}" "" __su_tmp_url "${__su_tmp_url}")
    endif()

    # Search for "DOMAIN" in the URL
    string(FIND "${__su_tmp_url}" "${__su_DOMAIN}" __su_domain_found)

    # Exit early if "DOMAIN" was not found in the URL
    if (__su_domain_found EQUAL -1)
        cpp_raise(
            InvalidURL
            "Hostname, ${__su_DOMAIN}, not found in URL: ${__su_url}"
        )
    endif()

    set("${__su_result}" "${__su_tmp_url}")
    cpp_return("${__su_result}")

endfunction()