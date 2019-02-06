################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()
include(get_recipe/get_from_url/get_from_github/get_from_github)
include(get_recipe/get_from_url/ctor)
include(get_recipe/get_from_url/factory_add_kwargs)
include(kwargs/kwargs)

## Dispatches among the various way to get source from the internet.
#
# This function is responsible for calling the correct ctor for the various
# classes derived from the ``GetFromURL`` class.
#
#
# :param handle: An identifier to hold the handle to the returned object.
# :param url: The URL to get the source from.
# :param kwargs: A Kwargs instance with inital values to forward to the ctors
function(_cpp_GetFromURL_factory _cGf_handle _cGf_url _cGf_kwargs)
    _cpp_GetFromURL_factory_add_kwargs(${_cGf_kwargs})
    _cpp_Kwargs_parse_argn(${_cGf_kwargs} ${ARGN})
    _cpp_contains(_cGf_is_gh "github.com" "${_cGf_url}" )
    if(_cGf_is_gh)
        _cpp_GetFromGithub_ctor(_cGf_temp "${_cGf_url}" ${_cGf_kwargs})
    else()
        _cpp_GetFromURL_ctor(_cGf_temp "${_cGf_url}" ${_cGf_kwargs})
    endif()
    _cpp_set_return(${_cGf_handle} ${_cGf_temp})
endfunction()
