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

## This function asserts that there are no unparsed kwargs
#
# This function is nothing more than a call to :ref:`cpp_is_empty-label` coupled
# to an error message. Nonetheless, given how often we don't want to support
# unparsed kwargs this function prevents quite a bit of code duplication.
#
# :param unparsed: The list of unparsed kwargs.
function(_cpp_kwargs_handle_unparsed _ckhu_unparsed)
    _cpp_is_empty(_ckhu_is_empty _ckhu_unparsed)
    if(_ckhu_is_empty)
        return()
    endif()
    _cpp_error("Found unparsed kwargs: ${_ckhu_unparsed}.")
endfunction()
