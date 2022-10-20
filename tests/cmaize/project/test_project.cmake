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

        ct_add_section(NAME "creates_default_project")
        function("${creates_default_project}")

            set(proj_name "test_project_test_ctor_creates_default_project")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            CMaizeProject(GET "${proj_obj}" result_name name)
            CMaizeProject(GET "${proj_obj}" specs specification)
            ProjectSpecification(GET "${specs}" spec_name name)
            ProjectSpecification(GET "${specs}" spec_version version)

            # Test name
            ct_assert_equal(result_name "${proj_name}")
            ct_assert_equal(spec_name "${proj_name}")

            # Test version
            ct_assert_equal(spec_version "")

            # Test languages
            # ct_assert_equal(result_languages NONE)

        endfunction()

        ct_add_section(NAME "creates_custom_project")
        function("${creates_custom_project}")

            set(proj_name "test_project_test_ctor_creates_custom_project")
            set(proj_version 0.1.0)
            set(proj_desc "Test project")
            set(proj_homepage "https://www.testproject.com")
            set(proj_languages NONE)

            CMaizeProject(CTOR proj_obj
                "${proj_name}"
                VERSION "${proj_version}"
                DESCRIPTION "${proj_desc}"
                HOMEPAGE_URL "${proj_homepage}"
                LANGUAGES "${proj_languages}"
            )

            CMaizeProject(GET "${proj_obj}" result_name name)
            CMaizeProject(GET "${proj_obj}" result_languages languages)
            CMaizeProject(GET "${proj_obj}" specs specification)
            ProjectSpecification(GET "${specs}" spec_name name)
            ProjectSpecification(GET "${specs}" spec_version version)

            # NOTE: <PROJECT_NAME>_<VARIABLE> CMake variables cannot be
            #       checked right now, since it seems that they are cleared
            #       after leaving the CMaizeProject(CTOR call. The checks
            #       that would be used are commented out.

            # Test name
            ct_assert_equal(result_name "${proj_name}")
            ct_assert_equal(spec_name "${proj_name}")

            # Test version
            # ct_assert_equal(${proj_name}_VERSION "${proj_version}")
            ct_assert_equal(spec_version "${proj_version}")

            # Test description
            # ct_assert_equal(${proj_name}_DESCRIPTION "${proj_desc}")

            # Test homepage URL
            # ct_assert_equal(${proj_name}_HOMEPAGE_URL "${proj_homepage}")

            # Test languages
            ct_assert_equal(result_languages NONE)
            
        endfunction()

    endfunction()

    ct_add_section(NAME "test_add_target")
    function("${test_add_target}")

        ct_add_section(NAME "single_target")
        function("${single_target}")

            set(proj_name "test_project_test_add_target_single_target")
            set(tgt_name "${proj_name}_tgt")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            BuildTarget(CTOR tgt_obj "${tgt_name}")

            CMaizeProject(GET "${proj_obj}" tmp_name name)        

            # Add a target
            CMaizeProject(add_target "${proj_obj}" "${tgt_obj}")

            CMaizeProject(GET "${proj_obj}" tgt_list targets)

            # Make sure there is an element in the targets list
            list(LENGTH tgt_list tgt_list_len)
            ct_assert_equal(tgt_list_len 1)

        endfunction()

        ct_add_section(NAME "duplicate_target")
        function("${duplicate_target}")

            set(proj_name "test_project_test_add_target_duplicate_target")
            set(tgt_name "${proj_name}_tgt")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            BuildTarget(CTOR tgt_obj "${tgt_name}")

            CMaizeProject(GET "${proj_obj}" tmp_name name)        

            # Duplicate target should not be successfully added
            CMaizeProject(add_target "${proj_obj}" "${tgt_obj}")
            CMaizeProject(add_target "${proj_obj}" "${tgt_obj}")

            CMaizeProject(GET "${proj_obj}" tgt_list targets)

            # Make sure there is an element in the targets list
            list(LENGTH tgt_list tgt_list_len)
            ct_assert_equal(tgt_list_len 1)

        endfunction()

        ct_add_section(NAME "multiple_targets")
        function("${multiple_targets}")

            set(proj_name "test_project_test_add_target_multiple_targets")
            set(tgt_name "${proj_name}_tgt")

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

            CMaizeProject(GET "${proj_obj}" tgt_list targets)

            # Make sure there is an element in the targets list
            list(LENGTH tgt_list tgt_list_len)
            ct_assert_equal(tgt_list_len 3)

        endfunction()

    endfunction()

endfunction()
