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
include(string/cpp_string_count)

## Given a list of keywords, ensures each keyword only appears once
#
# When working with kwargs, it is ambiguous if a kwarg appears more than once.
# For example assume we are looking for the kwarg "OPTION" and the user has
# provided the input "OPTION X OPTION Y". What should the value of OPTION be set
# to X or Y? Another situation, is when we are using functions that take
# callbacks. Here if the callback takes the same kwargs as our function there is
# no way to tell which kwarg belongs to your function and which kwarg belongs to
# the callback. This function will loop over the kwargs to your function and
# determine if any of them appear multiple times in the arguments the user
# provided. If any kwarg appears multiple times an error will be raised.
#
# :param kwargs: The list of kwargs to search for.
# :param argn: The arguments to search for the kwargs in.
function(_cpp_kwargs_unique _cku_kwargs _cku_argn)
    foreach(_cku_arg_i ${_cku_kwargs})
        _cpp_string_count(_cku_count "${_cku_arg_i}" "${_cku_argn}")
        if(${_cku_count} GREATER 1)
            _cpp_error(
                "The kwarg ${_cku_arg_i} appears ${_cku_count} times in "
                "the kwargs ${_cku_argn}. Please specify each kwarg at most "
                "once."
            )
        endif()
    endforeach()
endfunction()
