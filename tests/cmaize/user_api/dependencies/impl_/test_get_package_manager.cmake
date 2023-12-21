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
include(cmaize/user_api/cmaize_project)
include(cmaize/user_api/dependencies/impl_/get_package_manager)


ct_add_test(NAME "_fob_get_package_manager")
function("${_fob_get_package_manager}")

    ct_add_section(NAME "throws_if_invalid_name" EXPECTFAIL)
    function("${throws_if_invalid_name}")

        set(proj_name "test_fob_get_package_manager_throws_if_invalid_name")
        project("${proj_name}")
        cmaize_project("${proj_name}")
        cpp_get_global(proj_obj CMAIZE_TOP_PROJECT)

        _fob_get_package_manager(pm "${proj_obj}" "not_a_pm")

    endfunction()

    foreach(pm_name cmake pip)

        ct_add_section(NAME "get_${pm_name}")
        function("${get_${pm_name}}")

            set(proj_name "test_fob_get_package_manager_get_${pm_name}")
            project("${proj_name}")
            cmaize_project("${proj_name}")
            cpp_get_global(proj_obj CMAIZE_TOP_PROJECT)

            _fob_get_package_manager(pm "${proj_obj}" "${pm_name}")

            CMaizeProject(get_package_manager "${proj_obj}" corr "${pm_name}")
            PackageManager(EQUAL "${corr}" are_equal "${pm}")
            ct_assert_true(are_equal)

        endfunction()
    endforeach()

endfunction()
