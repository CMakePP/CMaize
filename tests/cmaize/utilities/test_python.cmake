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

include(cmake_test/cmake_test)
include(cmaize/utilities/python)

# Hard to do a better test for find_python w/o just repeating its contents
ct_add_test(NAME "test_find_python")
function("${test_find_python}")

    find_python(py_exe py_version)
    ct_assert_not_equal(py_exe "")
    ct_assert_not_equal(py_version "")

endfunction()


# To test that the virtual environment is property setup we just look for the
# "activate" script.
ct_add_test(NAME "test_create_virtual_env")
function("${test_create_virtual_env}")

    find_python(py_exe py_version)
    create_virtual_env(venv_dir "${py_exe}" "${CMAKE_BINARY_DIR}" "venv")

    ct_assert_file_exists("${venv_dir}/bin/activate")

endfunction()
