include(cmake_test/cmake_test)

#[[[
# Test the ``CMaizeProject`` class.
#]]
ct_add_test(NAME "test_project")
function("${test_project}")
    include(cmaize/project/project)

    #[[[
    # Test ``Target(CTOR`` method.
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
            ProjectSpecification(GET "${specs}" spec_name name)
            ProjectSpecification(GET "${specs}" spec_version version)

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
            ProjectSpecification(GET "${specs}" spec_name name)
            ProjectSpecification(GET "${specs}" spec_version version)

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
            CMaizeProject(add_target "${proj_obj}" "${tgt_obj}")

            CMaizeProject(GET "${proj_obj}" tgt_list build_targets)

            # Make sure there is an element in the targets list
            list(LENGTH tgt_list tgt_list_len)
            ct_assert_equal(tgt_list_len 1)

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
            CMaizeProject(add_target "${proj_obj}" "${tgt_obj}" INSTALLED)

            CMaizeProject(GET "${proj_obj}" build_tgt_list build_targets)
            CMaizeProject(GET "${proj_obj}" installed_tgt_list installed_targets)

            # Make sure there is an element in the targets list
            list(LENGTH build_tgt_list build_tgt_list_len)
            ct_assert_equal(build_tgt_list_len 0)

            list(LENGTH installed_tgt_list installed_tgt_list_len)
            ct_assert_equal(installed_tgt_list_len 1)

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
            CMaizeProject(add_target "${proj_obj}" "${build_tgt_obj}")
            CMaizeProject(add_target "${proj_obj}" "${build_tgt_obj}")
            CMaizeProject(add_target "${proj_obj}" "${installed_tgt_obj}" INSTALLED)

            CMaizeProject(GET "${proj_obj}" build_tgt_list build_targets)
            CMaizeProject(GET "${proj_obj}" installed_tgt_list installed_targets)

            # Make sure there is an element in the targets list
            list(LENGTH build_tgt_list build_tgt_list_len)
            ct_assert_equal(build_tgt_list_len 1)

            list(LENGTH installed_tgt_list installed_tgt_list_len)
            ct_assert_equal(installed_tgt_list_len 0)

        endfunction()

        ct_add_section(NAME "multiple_targets")
        function("${multiple_targets}")

            set(proj_name "test_project_test_add_target_multiple_targets")
            set(tgt_name "${proj_name}_tgt")

            project("${proj_name}")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            BuildTarget(CTOR tgt_obj_1 "${tgt_name}_1")
            BuildTarget(CTOR tgt_obj_2 "${tgt_name}_2")
            BuildTarget(CTOR tgt_obj_3 "${tgt_name}_3")

            CMaizeProject(GET "${proj_obj}" tmp_name name)        

            # Add three distinct targets
            CMaizeProject(add_target "${proj_obj}" "${tgt_obj_1}")
            CMaizeProject(add_target "${proj_obj}" "${tgt_obj_2}")
            CMaizeProject(add_target "${proj_obj}" "${tgt_obj_3}")
            # Duplicate target should not be successfully added
            CMaizeProject(add_target "${proj_obj}" "${tgt_obj_1}")

            CMaizeProject(GET "${proj_obj}" tgt_list build_targets)

            # Make sure there are the corrent number of elements in
            # the targets list
            list(LENGTH tgt_list tgt_list_len)
            ct_assert_equal(tgt_list_len 3)

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

endfunction()
