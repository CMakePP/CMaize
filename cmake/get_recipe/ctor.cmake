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

## Constructor for the GetRecipe  baseclass
#
# Get recipes are responsible for being able to get a tarball of a dependency's
# source code. There are a variety of mechanisms for doing this and each one of
# those mechanisms is implemented as class derived from the ``GetRecipe`` class.
#
# Members:
#
# * url - If non-empty, a url to download the source from
# * dir - If non-empty, a directory to copy the source from
#
#
function(_cpp_GetRecipe_constructor _cGc_instance)
    _cpp_Object_constructor(_cGc_handle)
    _cpp_Object_set_type(${_cGc_handle} GetRecipe)
    _cpp_Object_add_members(${_cGc_handle} url dir)
endfunction()
