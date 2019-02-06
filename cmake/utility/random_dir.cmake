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

include(logic/is_not_directory)
include(utility/assert_no_extra_args)
include(utility/set_return)

## Generates a new, randomly named directory at the specified path
#
# Particularly for testing purposes we often need to generate a directory to
# store stuff in that doesn't conflict with other directories. This function
# generates a new randomly named directory in the requested directory.
#
# :param result: An identifier to hold the resulting path.
# :param prefix: The directory to create the random directory in.
function(_cpp_random_dir _crd_result _crd_prefix)
    _cpp_assert_no_extra_args("${ARGN}")
    while(TRUE)
        string(RANDOM _crd_suffix)
        set(_crd_dir "${_crd_prefix}/${_crd_suffix}")
        _cpp_is_not_directory(_crd_good "${_crd_dir}")
        if(_crd_good)
            break()
        endif()
    endwhile()
    file(MAKE_DIRECTORY ${_crd_dir})
    _cpp_set_return(${_crd_result} ${_crd_dir})
endfunction()
