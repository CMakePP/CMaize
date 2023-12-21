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

macro(_pip_install_package self _ip_package_specs)

    PipPackageManager(GET "${self}" _ip_py_exe python_executable)
    PackageSpecification(GET "${_ip_package_specs}" _ip_name name)
    execute_process(
        COMMAND "${_ip_py_exe}" "-m" "pip" "install" "${_ip_name}"
        OUTPUT_QUIET
    )

endmacro()
