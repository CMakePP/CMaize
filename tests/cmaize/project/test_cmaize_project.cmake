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

#[[[
# Test the ``CMaizeProject`` class.
#]]
ct_add_test(NAME "test_project")
function("${test_project}")
    include(cmaize/project/cmaize_project)

    #[[[
    # Test ``CMaizeTarget(CTOR`` method.
    #]]
    ct_add_section(NAME "test_ctor")
    function("${test_ctor}")

        ct_add_section(NAME "no_project" EXPECTFAIL)
        function("${no_project}")

            set(proj_name "test_project_test_ctor_no_project")

            # no project() call
            # project("${proj_name}")

            # This should throw an exception
            CMaizeProject(CTOR proj_obj "${proj_name}")

        endfunction()

        ct_add_section(NAME "default_project")
        function("${default_project}")

            set(proj_name "test_project_test_ctor_default_project")

            project("${proj_name}")
            CMaizeProject(CTOR proj_obj "${proj_name}")

            CMaizeProject(GET "${proj_obj}" result_name name)
            CMaizeProject(GET "${proj_obj}" specs specification)
            PackageSpecification(GET "${specs}" spec_name name)
            PackageSpecification(GET "${specs}" spec_version version)

            # Test name
            ct_assert_equal(result_name "${proj_name}")
            ct_assert_equal(spec_name "${proj_name}")

            # Test version
            ct_assert_equal(spec_version "${proj_version}")
            ct_assert_equal(spec_version "${${proj_name}_VERSION}")

            # Test languages
            ct_assert_equal(result_languages "")

        endfunction()

        ct_add_section(NAME "creates_custom_project")
        function("${creates_custom_project}")

            set(proj_name "test_project_test_ctor_creates_custom_project")
            set(proj_version 0.1.0)
            set(proj_desc "Test project")
            set(proj_homepage "https://www.testproject.com")
            set(proj_languages NONE)

            project(
                "${proj_name}"
                VERSION "${proj_version}"
                DESCRIPTION "${proj_desc}"
                HOMEPAGE_URL "${proj_homepage}"
                LANGUAGES "${proj_languages}"
            )

            CMaizeProject(CTOR proj_obj "${proj_name}")

            CMaizeProject(GET "${proj_obj}" result_name name)
            CMaizeProject(GET "${proj_obj}" result_languages languages)
            CMaizeProject(GET "${proj_obj}" specs specification)
            PackageSpecification(GET "${specs}" spec_name name)
            PackageSpecification(GET "${specs}" spec_version version)

            # Test name
            ct_assert_equal(result_name "${proj_name}")
            ct_assert_equal(spec_name "${proj_name}")

            # Test version
            ct_assert_equal(spec_version "${proj_version}")
            ct_assert_equal(spec_version "${${proj_name}_VERSION}")

            # Test languages
            ct_assert_equal(result_languages "")

        endfunction()

    endfunction()

    ct_add_section(NAME "test_add_target")
    function("${test_add_target}")
        include(cmaize/targets/build_target)
        include(cmaize/targets/installed_target)

        ct_add_section(NAME "build_target")
        function("${build_target}")

            set(proj_name "test_project_test_add_target_build_target")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            BuildTarget(CTOR tgt_obj "${tgt_name}")

            CMaizeProject(GET "${proj_obj}" tmp_name name)

            # Add a target
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}" "${tgt_obj}")

            # Get the build target collection for testing
            CMaizeProject(GET "${proj_obj}" tgt_dict build_targets)

            # Make sure there is an element in the targets list
            cpp_map(KEYS "${tgt_dict}" keys_list)
            list(LENGTH keys_list keys_list_len)
            ct_assert_equal(keys_list_len 1)

            # Make sure that the correct key is in the collection
            cpp_map(HAS_KEY "${tgt_dict}" tmp_found "${tgt_name}")
            ct_assert_equal(tmp_found TRUE)

            # Make sure that the correct object is stored at the key
            cpp_map(GET "${tgt_dict}" tmp_tgt_obj "${tgt_name}")
            CMaizeTarget(target "${tmp_tgt_obj}" tmp_tgt_obj_name)
            ct_assert_equal(tgt_name "${tmp_tgt_obj_name}")

        endfunction()

        ct_add_section(NAME "installed_target")
        function("${installed_target}")

            set(proj_name "test_project_test_add_target_installed_target")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            InstalledTarget(CTOR tgt_obj "${tgt_name}")

            CMaizeProject(GET "${proj_obj}" tmp_name name)

            # Add a target
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}" "${tgt_obj}" INSTALLED)

            CMaizeProject(GET "${proj_obj}" build_tgt_map build_targets)
            CMaizeProject(GET "${proj_obj}" installed_tgt_map installed_targets)
            cpp_map(KEYS "${build_tgt_map}" build_tgt_keys_list)
            cpp_map(KEYS "${installed_tgt_map}" installed_tgt_keys_list)

            # Make sure there is no element in the build_targets list
            list(LENGTH build_tgt_keys_list build_tgt_keys_list_len)
            ct_assert_equal(build_tgt_keys_list_len 0)

            # Make sure that there is no key in the collection
            cpp_map(HAS_KEY "${build_tgt_map}" tmp_found "${tgt_name}")
            ct_assert_equal(tmp_found FALSE)

            # Make sure there is an element in the installed_targets list
            list(LENGTH installed_tgt_keys_list installed_tgt_keys_list_len)
            ct_assert_equal(installed_tgt_keys_list_len 1)

            # Make sure that the correct key is in the collection
            cpp_map(HAS_KEY "${installed_tgt_map}" tmp_found "${tgt_name}")
            ct_assert_equal(tmp_found TRUE)

            # Make sure that the correct object is stored at the key
            cpp_map(GET "${installed_tgt_map}" tmp_tgt_obj "${tgt_name}")
            CMaizeTarget(target "${tmp_tgt_obj}" tmp_tgt_obj_name)
            ct_assert_equal(tgt_name "${tmp_tgt_obj_name}")

        endfunction()

        ct_add_section(NAME "duplicate_target")
        function("${duplicate_target}")

            set(proj_name "test_project_test_add_target_duplicate_target")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            BuildTarget(CTOR build_tgt_obj "${tgt_name}")
            InstalledTarget(CTOR installed_tgt_obj "${tgt_name}")

            CMaizeProject(GET "${proj_obj}" tmp_name name)

            # Duplicate targets should not be successfully added
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}" "${build_tgt_obj}")
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}" "${build_tgt_obj}")
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}" "${installed_tgt_obj}" INSTALLED)

            CMaizeProject(GET "${proj_obj}" build_tgt_map build_targets)
            CMaizeProject(GET "${proj_obj}" installed_tgt_map installed_targets)
            cpp_map(KEYS "${build_tgt_map}" build_tgt_keys_list)
            cpp_map(KEYS "${installed_tgt_map}" installed_tgt_keys_list)

            # Make sure there is an element in the build_targets list
            list(LENGTH build_tgt_keys_list build_tgt_keys_list_len)
            ct_assert_equal(build_tgt_keys_list_len 1)

            # Make sure that the correct key is in the collection
            cpp_map(HAS_KEY "${build_tgt_map}" tmp_found "${tgt_name}")
            ct_assert_equal(tmp_found TRUE)

            # Make sure that the correct object is stored at the key
            cpp_map(GET "${build_tgt_map}" tmp_tgt_obj "${tgt_name}")
            CMaizeTarget(target "${tmp_tgt_obj}" tmp_tgt_obj_name)
            ct_assert_equal(tgt_name "${tmp_tgt_obj_name}")

            # Make sure there is an element in the installed_targets list
            list(LENGTH installed_tgt_keys_list installed_tgt_keys_list_len)
            ct_assert_equal(installed_tgt_keys_list_len 0)

            # Make sure that there is no key in the collection
            cpp_map(HAS_KEY "${installed_tgt_map}" tmp_found "${tgt_name}")
            ct_assert_equal(tmp_found FALSE)

        endfunction()

        ct_add_section(NAME "duplicate_target_overwrite")
        function("${duplicate_target_overwrite}")

            set(proj_name "test_project_test_add_target_duplicate_target_overwrite")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            BuildTarget(CTOR build_tgt_obj_1 "${tgt_name}_1")
            BuildTarget(CTOR build_tgt_obj_2 "${tgt_name}_2")
            set(corr_tgt_name "${tgt_name}_2")

            CMaizeProject(GET "${proj_obj}" tmp_name name)        

            # Duplicate targets should not be successfully added
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}" "${build_tgt_obj_1}")
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}" "${build_tgt_obj_2}" OVERWRITE)

            CMaizeProject(GET "${proj_obj}" build_tgt_map build_targets)
            cpp_map(KEYS "${build_tgt_map}" build_tgt_keys_list)

            # Make sure there is an element in the build_targets list
            list(LENGTH build_tgt_keys_list build_tgt_keys_list_len)
            ct_assert_equal(build_tgt_keys_list_len 1)

            # Make sure that the correct key is in the collection
            cpp_map(HAS_KEY "${build_tgt_map}" tmp_found "${tgt_name}")
            ct_assert_equal(tmp_found TRUE)

            # Make sure that the correct object is stored at the key
            cpp_map(GET "${build_tgt_map}" tmp_tgt_obj "${tgt_name}")
            CMaizeTarget(target "${tmp_tgt_obj}" tmp_tgt_obj_name)
            ct_assert_equal(corr_tgt_name "${tmp_tgt_obj_name}")

        endfunction()

        ct_add_section(NAME "duplicate_target_overwrite_different_map")
        function("${duplicate_target_overwrite_different_map}")

            set(proj_name "test_project_test_add_target_duplicate_target_overwrite_different_map")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            BuildTarget(CTOR build_tgt_obj "${tgt_name}")
            InstalledTarget(CTOR installed_tgt_obj "${tgt_name}")

            CMaizeProject(GET "${proj_obj}" tmp_name name)        

            # Duplicate targets should not be successfully added
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}" "${build_tgt_obj}")
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}" "${build_tgt_obj}")
            # Unless the OVERWRITE option is given
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}" "${installed_tgt_obj}" INSTALLED OVERWRITE)

            CMaizeProject(GET "${proj_obj}" build_tgt_map build_targets)
            CMaizeProject(GET "${proj_obj}" installed_tgt_map installed_targets)
            cpp_map(KEYS "${build_tgt_map}" build_tgt_keys_list)
            cpp_map(KEYS "${installed_tgt_map}" installed_tgt_keys_list)

            # Make sure there is an element in the build_targets list
            list(LENGTH build_tgt_keys_list build_tgt_keys_list_len)
            ct_assert_equal(build_tgt_keys_list_len 1)

            # Make sure that the correct key is in the collection
            cpp_map(HAS_KEY "${build_tgt_map}" tmp_found "${tgt_name}")
            ct_assert_equal(tmp_found TRUE)

            # Make sure that the correct object is stored at the key (nothing)
            cpp_map(GET "${build_tgt_map}" tmp_tgt_obj "${tgt_name}")
            ct_assert_equal("" "${tmp_tgt_obj}")

            # Make sure there is an element in the installed_targets list
            list(LENGTH installed_tgt_keys_list installed_tgt_keys_list_len)
            ct_assert_equal(installed_tgt_keys_list_len 1)

            # Make sure that the correct key is in the collection
            cpp_map(HAS_KEY "${installed_tgt_map}" tmp_found "${tgt_name}")
            ct_assert_equal(tmp_found TRUE)

            # Make sure that the correct object is stored at the key
            cpp_map(GET "${installed_tgt_map}" tmp_tgt_obj "${tgt_name}")
            CMaizeTarget(target "${tmp_tgt_obj}" tmp_tgt_obj_name)
            ct_assert_equal(tgt_name "${tmp_tgt_obj_name}")

        endfunction()

        ct_add_section(NAME "multiple_targets")
        function("${multiple_targets}")

            set(proj_name "test_project_test_add_target_multiple_targets")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            BuildTarget(CTOR tgt_obj_1 "${tgt_name}_1")
            BuildTarget(CTOR tgt_obj_2 "${tgt_name}_2")

            CMaizeProject(GET "${proj_obj}" tmp_name name)

            # Add three distinct targets
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}_1" "${tgt_obj_1}")
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}_2" "${tgt_obj_2}")
            # Duplicate target should not be successfully added
            CMaizeProject(add_target "${proj_obj}" "${tgt_name}_1" "${tgt_obj_1}")

            CMaizeProject(GET "${proj_obj}" tgt_dict build_targets)
            cpp_map(KEYS "${tgt_dict}" keys_list)

            # Make sure there are the corrent number of elements in
            # the targets list
            list(LENGTH keys_list keys_list_len)
            ct_assert_equal(keys_list_len 2)

            # Make sure that the correct key is in the collection
            cpp_map(HAS_KEY "${tgt_dict}" tmp_found "${tgt_name}_1")
            ct_assert_equal(tmp_found TRUE)

            # Make sure that the correct object is stored at the key
            cpp_map(GET "${tgt_dict}" tmp_tgt_obj "${tgt_name}_1")
            CMaizeTarget(target "${tmp_tgt_obj}" tmp_tgt_obj_name)
            ct_assert_equal(tmp_tgt_obj_name "${tgt_name}_1")

            # Make sure that the correct key is in the collection
            cpp_map(HAS_KEY "${tgt_dict}" tmp_found "${tgt_name}_2")
            ct_assert_equal(tmp_found TRUE)

            # Make sure that the correct object is stored at the key
            cpp_map(GET "${tgt_dict}" tmp_tgt_obj "${tgt_name}_2")
            CMaizeTarget(target "${tmp_tgt_obj}" tmp_tgt_obj_name)
            ct_assert_equal(tmp_tgt_obj_name "${tgt_name}_2")

        endfunction()

    endfunction()

    ct_add_section(NAME "test_get_target")
    function("${test_get_target}")
        include(cmaize/targets/build_target)
        include(cmaize/targets/installed_target)

        ct_add_section(NAME "build_target")
        function("${build_target}")

            set(proj_name "test_project_test_add_target_build_target")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            BuildTarget(CTOR tgt_obj "${tgt_name}")

            # Add the target to the map
            CMaizeProject(GET "${proj_obj}" _build_targets build_targets)
            cpp_map(SET "${_build_targets}" "${tgt_name}" "${tgt_obj}")

            CMaizeProject(get_target "${proj_obj}" _tgt_obj "${tgt_name}")

            CMaizeTarget(target "${_tgt_obj}" _tgt_obj_name)
            ct_assert_equal(tgt_name "${_tgt_obj_name}")

        endfunction()

        ct_add_section(NAME "installed_target")
        function("${installed_target}")

            set(proj_name "test_project_test_add_target_installed_target")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            InstalledTarget(CTOR tgt_obj "${tgt_name}")

            # Add the target to the map
            CMaizeProject(GET
                "${proj_obj}" _installed_targets installed_targets
            )
            cpp_map(SET "${_installed_targets}" "${tgt_name}" "${tgt_obj}")

            CMaizeProject(get_target
                "${proj_obj}" _tgt_obj "${tgt_name}" INSTALLED
            )

            CMaizeTarget(target "${_tgt_obj}" _tgt_obj_name)
            ct_assert_equal(tgt_name "${_tgt_obj_name}")

        endfunction()

    endfunction()

    ct_add_section(NAME "test_add_language")
    function("${test_add_language}")

        ct_add_section(NAME "duplicate_languages")
        function("${duplicate_languages}")

            set(proj_name "test_project_test_add_language_duplicate_languages")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            # Add two distinct languages
            CMaizeProject(add_language "${proj_obj}" C)
            CMaizeProject(add_language "${proj_obj}" C)

            CMaizeProject(GET "${proj_obj}" lang_list languages)

            # Make sure there is an element in the languages list
            list(LENGTH lang_list lang_list_len)
            ct_assert_equal(lang_list_len 1)

            # Test that the list contents are correct
            ct_assert_equal(lang_list "C")

        endfunction()

        ct_add_section(NAME "multiple_languages")
        function("${multiple_languages}")

            set(proj_name "test_project_test_add_language_multiple_languages")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            # Add two distinct languages
            CMaizeProject(add_language "${proj_obj}" C)
            CMaizeProject(add_language "${proj_obj}" CXX)

            CMaizeProject(GET "${proj_obj}" lang_list languages)

            # Make sure there is an element in the languages list
            list(LENGTH lang_list lang_list_len)
            ct_assert_equal(lang_list_len 2)

            # Test that the list contents are correct
            ct_assert_equal(lang_list "C;CXX")

        endfunction()

    endfunction()

    #[[[
    # Tests the set_option method by comparing to the correct map
    #]]
    ct_add_section(NAME "test_set_config_option")
    function("${test_set_config_option}")

        set(proj_name "test_project_test_set_config_option")
        project("${proj_name}")
        CMaizeProject(CTOR proj_obj "${proj_name}")
        CMaizeProject(set_config_option "${proj_obj}" "Hello" "World!!!")

        # Prepare the correct answer
        PackageSpecification(CTOR corr)
        PackageSpecification(set_config_option "${corr}" "Hello" "World!!!")

        CMaizeProject(GET "${proj_obj}" config_options specification)
        PackageSpecification(EQUAL "${corr}" result "${config_options}")
        ct_assert_equal(result TRUE)

        # Now we test what happens if set_option is called again
        ct_add_section(NAME "can_overwrite_option")
        function("${can_overwrite_option}")

            CMaizeProject(set_config_option "${proj_obj}" "Hello" 42)
            PackageSpecification(EQUAL "${corr}" result "${config_options}")
            ct_assert_equal(result FALSE)

            PackageSpecification(
                get_config_option "${config_options}" option_value "Hello"
            )
            ct_assert_equal(option_value 42)

        endfunction()

    endfunction()

    #[[[
    # Tests the getter for configuration options
    #]]
    ct_add_section(NAME "test_get_config_option")
    function("${test_get_config_option}")

        set(proj_name "test_project_test_get_config_option")
        project("${proj_name}")
        CMaizeProject(CTOR proj_obj "${proj_name}")
        CMaizeProject(set_config_option "${proj_obj}" "Hello" "World!!!")
        CMaizeProject(get_config_option "${proj_obj}" option_value "Hello")
        ct_assert_equal(option_value "World!!!")

        ct_add_section(NAME "throws_if_bad_key" EXPECTFAIL)
        function("${throws_if_bad_key}")
            CMaizeProject(
                get_config_option "${proj_obj}" option_value "Not a Key!"
            )
        endfunction()

    endfunction()

    #[[[
    # Tests checking if a config option has been defined.
    #]]
    ct_add_section(NAME "test_has_config_option")
    function("${test_has_config_option}")

        set(proj_name "test_project_test_has_config_option")
        project("${proj_name}")
        CMaizeProject(CTOR proj_obj "${proj_name}")

        # Option does not exist
        CMaizeProject(has_config_option "${proj_obj}" has_hello "Hello")
        ct_assert_false(has_hello)

        #Option exists
        CMaizeProject(set_config_option "${proj_obj}" "Hello" "World!!!")
        CMaizeProject(has_config_option "${proj_obj}" has_hello "Hello")
        ct_assert_true(has_hello)

    endfunction()


    ct_add_section(NAME "test_add_package_manager")
    function("${test_add_package_manager}")
        include(cmaize/package_managers/package_managers)

        ct_add_section(NAME "single_package_manager")
        function("${single_package_manager}")

            set(proj_name "test_project_test_add_package_manager_single_package_manager")
            set(pm_name "${proj_name}_pm")

            project("${proj_name}")
            CMaizeProject(CTOR proj_obj "${proj_name}")

            CMakePackageManager(CTOR pm_obj)

            # Try to add a package manager
            CMaizeProject(add_package_manager "${proj_obj}" "${pm_obj}")

            CMaizeProject(GET "${proj_obj}" pm_map package_managers)
            cpp_map(KEYS "${pm_map}" keys_list)

            # Make sure there is an element in the package_managers dict
            list(LENGTH keys_list keys_list_len)
            ct_assert_equal(keys_list_len 1)

        endfunction()

        ct_add_section(NAME "duplicate_package_manager")
        function("${duplicate_package_manager}")

            set(proj_name "test_project_test_add_package_manager_duplicate_package_manager")
            set(pm_name "${proj_name}_pm")

            project("${proj_name}")
            CMaizeProject(CTOR proj_obj "${proj_name}")

            CMakePackageManager(CTOR pm_obj)

            # Try to add a package manager
            CMaizeProject(add_package_manager "${proj_obj}" "${pm_obj}")
            # This should not add the object again
            CMaizeProject(add_package_manager "${proj_obj}" "${pm_obj}")

            CMaizeProject(GET "${proj_obj}" pm_dict package_managers)
            cpp_map(KEYS "${pm_dict}" keys_list)

            # Make sure there is only element in the package_managers dict
            list(LENGTH keys_list keys_list_len)
            ct_assert_equal(keys_list_len 1)

        endfunction()

        ct_add_section(NAME "multiple_package_managers")
        function("${multiple_package_managers}")

            set(proj_name "test_project_test_add_package_manager_multiple_package_managers")
            set(pm_name "${proj_name}_pm")

            project("${proj_name}")
            CMaizeProject(CTOR proj_obj "${proj_name}")

            CMakePackageManager(CTOR pm_obj_1)
            PackageManager(CTOR pm_obj_2)

            # Try to add a package manager
            CMaizeProject(add_package_manager "${proj_obj}" "${pm_obj_1}")
            # This should not add the object again
            CMaizeProject(add_package_manager "${proj_obj}" "${pm_obj_1}")
            # The different package manager should get added
            CMaizeProject(add_package_manager "${proj_obj}" "${pm_obj_2}")

            CMaizeProject(GET "${proj_obj}" pm_dict package_managers)
            cpp_map(KEYS "${pm_dict}" keys_list)

            # Make sure there are enough elements in the package_managers dict
            list(LENGTH keys_list keys_list_len)
            ct_assert_equal(keys_list_len 2)

        endfunction()

    endfunction()

endfunction()
