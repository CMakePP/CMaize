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

        ct_add_section(NAME "test_project_created")
        function("${test_project_created}")
            set(proj_name "test_project_test_ctor_test_project_created")

            CMaizeProject(CTOR proj_obj "${proj_name}")

            CMaizeProject(GET "${proj_obj}" result_name name)
            CMaizeProject(GET "${proj_obj}" result_languages languages)
            CMaizeProject(GET "${proj_obj}" specs specification)

            # project("${proj_name}")
            # message("Project name: ${PROJECT_NAME}")
            message("Source dir: ${${proj_name}_SOURCE_DIR}")
            ct_assert_equal(result_name "${proj_name}")
            ct_assert_equal(result_languages "${${proj_name}_VERSION}")
            
            # Test the project specification details
            ProjectSpecification(GET "${specs}" spec_name name)
            ct_assert_equal(spec_name "${proj_name}")
            ProjectSpecification(GET "${specs}" spec_version version)
            ct_assert_equal(spec_version "")
            ProjectSpecification(GET "${specs}" spec_build_type build_type)
            ct_assert_equal(spec_build_type "${CMAKE_BUILD_TYPE}")

        endfunction()

    endfunction()

endfunction()
