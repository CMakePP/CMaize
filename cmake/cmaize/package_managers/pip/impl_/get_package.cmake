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

macro(_pip_get_package self _gp_result _gp_package_specs)

    PipPackageManager(find_installed "${self}" "${_gp_result}" "${_gp_package_specs}")

    if("${_gp_result}" STREQUAL "")
        PackageSpecification(GET "${_gp_package_specs}" _gp_name name)
        cpp_raise(
            PACKAGE_NOT_FOUND "Unable to locate Python module: ${_gp_name}"
        )
    endif()

    cpp_return("${_gp_result}")

endmacro()
