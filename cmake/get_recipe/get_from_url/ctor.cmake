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
include(object/object)
include(get_recipe/ctor)
include(utility/set_return)

## Constructs an instance of the derived GetRecipe type GetFromURL
#
# The GetFromURL class is the base class for classes that obtain the source code
# from the internets. It extends GetRecipe by adding a member ``url`` which
# holds the URL for obtaining the source code.
#
# :param handle: An identifier to hold the handle to the returned object.
# :param url: The URL to download the source from
# :param version: The version of the dependency this get recipe fetches.
function(_cpp_GetFromURL_ctor _cGc_handle _cGc_url _cGc_version)
    _cpp_is_empty(_cGc_no_url _cGc_url)
    if(_cGc_no_url)
        _cpp_error("No URL was specified.")
    endif()

    _cpp_GetRecipe_ctor(_cGc_temp "${_cGc_version}")
    _cpp_Object_add_members(${_cGc_temp} url)
    _cpp_Object_set_value(${_cGc_temp} url "${_cGc_url}")
    _cpp_Object_set_type(${_cGc_temp} GetFromURL)
    _cpp_set_return(${_cGc_handle} ${_cGc_temp})
endfunction()
