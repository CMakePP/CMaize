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
include(get_recipe/get_from_url/ctor_add_kwargs)

## Adds ``GetFromGitHub``'s ctor's kwargs to a ``Kwargs`` instance.
#
# :param kwargs: The ``Kwargs`` instance to populate.
function(_cpp_GetFromGitHub_ctor_add_kwargs _cGcak_kwargs)
    _cpp_GetFromURL_ctor_add_kwargs(${_cGcak_kwargs})
    _cpp_Kwargs_add_keywords(${_cGcak_kwargs} TOGGLES PRIVATE OPTIONS BRANCH)
    _cpp_Kwargs_set_default(${_cGcak_kwargs} BRANCH master)
endfunction()
