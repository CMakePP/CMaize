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

#[[[
# Wraps the process of finding Python and working out the version we found.
#
# :param py_exe: Variable which will hold the path to the found Python
#    interpreter.
# :type py_exe: path*
# :param version: The version of the interpreter in the format major.minor.
# :type version: str
#]]
function(find_python _fp_py_exe _fp_version)

    find_package(Python3 COMPONENTS Interpreter QUIET REQUIRED)
    set("${_fp_py_exe}" "${Python3_EXECUTABLE}" PARENT_SCOPE)
    set(
        "${_fp_version}"
        "${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}"
        PARENT_SCOPE
    )

endfunction()

#[[[
# Wraps the process of creating a Python virtual environment
#
# :param venv_dir: Variable to hold the path to the virtual environment
# :type venv_dir: path*
# :param py_exe: The Python executable to use to create the environment.
# :type py_exe: path
# :param dir: The directory in which to create the virtual environment
# :type dir: path
# :param name: The name for the virtual environment.
# :type name: str
#]]
function(create_virtual_env _cve_venv_dir _cve_py_exe _cve_dir _cve_name)
    execute_process(
        COMMAND "${_cve_py_exe}" "-m" "venv" "${_cve_name}"
        WORKING_DIRECTORY "${_cve_dir}"
    )
    set(
        "${_cve_venv_dir}" "${_cve_dir}/${_cve_name}" PARENT_SCOPE
    )
endfunction()
