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

## Macro that wraps returning a value from a function
#
# While the syntax to return a value from a function in CMake is not superhard
# (it's just ``set(return_identifier return_value PARENT_SCOPE)``) it's easy to
# forget the ``PARENT_SCOPE`` (plus the fact that it's all caps makes it
# slightly annoying to type repeatedly) which leads to subtle errors. The syntax
# is also not super descriptive of what is going on. This macro wraps the CMake
# ``set`` function call in a more descriptive call that doesn't require you to
# remember the ``PARENT_SCOPE``.
#
# :param identifier: The identifier we are setting the value of.
# :param value: The value to set the identifier to.
macro(_cpp_set_return _csr_identifier _csr_value)
    set(${_csr_identifier} "${_csr_value}" PARENT_SCOPE)
endmacro()
