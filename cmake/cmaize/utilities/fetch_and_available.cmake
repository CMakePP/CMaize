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
include(FetchContent)

#[[[ Fetches and makes a dependency available to the main project
#
# This function is code-factorization for the common scenario in which we want
# to declare a dependency (and how to obtain that dependency) and immediately
# make that dependency available to the project. This function is ultimately a
# thin wrapper around ``FetchContent_Declare`` and
# ``FetchContent_MakeAvailable``.
#
# :param _faa_name: The name of the dependency we are making available. This
#                   should be the dependency's official name as it would be used
#                   by other projects.
# :type _faa_name: desc
# :param **kwargs: The additional arguments to forward to ``FetchContent_Declare``.
#]]
macro(cmaize_fetch_and_available _faa_name)

    FetchContent_Declare("${_faa_name}" ${ARGN})
    FetchContent_MakeAvailable("${_faa_name}")
    
endmacro()
