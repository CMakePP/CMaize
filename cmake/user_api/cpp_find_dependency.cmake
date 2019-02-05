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
include(kwargs/kwargs)
include(user_api/find_dependency_guts)

## Function for finding a dependency.
#
# This function is the public API for users who want CPP to find a dependency
# that the end-user is responsible for building (*i.e.*, this function is the
# public API for finding a dependency that CPP can not build). This function is
# also used internally in :ref:`cpp_find_or_build_dependency-label` to handle the
# "finding" part.
#
# :kwargs:
#
#     * *NAME* (``option``) - The name of the dependency we are looking for.
#     * *VERSION* (``option``) - The version of the dependency we are looking
#       for.
#     * *COMPONENTS* (``list``) - A list of components that the dependency must
#       provide.
#     * *FIND_MODULE* (``option``) - The path to a user provided find module.
#     * *RESULT* (``option``) - An identifier in which to store whether or not
#       the dependency was found. Result is thrown away by default.
#     * *OPTIONAL* (``toggle``) - If present, failing to find the dependency is
#       **NOT** an error.
#
function(cpp_find_dependency)
    _cpp_Kwargs_ctor(_cfd_kwargs)
    _cpp_find_dependency_guts(${_cfd_kwargs} ${ARGN})
endfunction()
