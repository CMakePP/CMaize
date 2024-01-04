# Copyright 2024 CMakePP
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

include(cmaize/user_api/dependencies/impl_/check_optional_flag)
include(cmaize/user_api/dependencies/find_or_build_dependency)

#[[[
# Wraps the process of finding, or building, an optional dependency.
#
# This method is largely the same as cmaize_find_optional_dependency, but
# instead wraps a call to ``cmaize_find_or_build_dependency``.
#
# :param name: The name of the dependency.
# :type name: desc
# :param flag: The variable to use as a flag. Used to name the compile
#    definition.
# :type flag: desc
# :param kwargs: Keyword arguments to forward to
#    ``cmaize_find_or_build_dependency``. See the documentation for
#    ``cmaize_find_or_build_dependency`` for the full list.
#]]
function(cmaize_find_or_build_optional_dependency _cfobod_name _cfobod_flag)

    _check_optional_flag("${_cfobod_flag}")

    if("${${_cfobod_flag}}")

        cmaize_find_or_build_dependency("${_cfobod_name}" ${ARGN})
        target_compile_definitions(
            "${_cfobod_name}" INTERFACE "${_cfobod_flag}"
        )

    elseif(NOT TARGET "${_cfobod_name}")

        add_library("${_cfobod_name}" INTERFACE)

    endif()

endfunction()
