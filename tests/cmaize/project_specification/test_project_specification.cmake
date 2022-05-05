include(cmake_test/cmake_test)

#[[[
# Test the functionalities of the ProjectSpecification class.
#]]
ct_add_test(NAME "test_project_specification")
function("${test_project_specification}")
    include(cmaize/project_specification/project_specification)

    #[[[
    # Test that the constructor is working with different arguments.
    #]]
    ct_add_section(NAME "test_constructor")
    function("${test_constructor}")

        #[[[
        # Test when no toolchain path or content argument is provided.
        # This should give default, autopopulated options for the
        # toolchain options.
        #]]
        ct_add_section(NAME "empty_toolchain")
        function("${empty_toolchain}")

            # Create a toolchain object with no user options
            ProjectSpecification(CTOR ps_obj)

            # The file content should be blank
            ProjectSpecification(GET "${ps_obj}" _ps name version build_type)
            ct_assert_equal(_ps_name "${PROJECT_NAME}")
            ct_assert_equal(_ps_version "")
            ct_assert_equal(_ps_build_type "${CMAKE_BUILD_TYPE}")

        endfunction()

    endfunction()

    #[[[
    # Test setting the version.
    #]]
    ct_add_section(NAME "test_set_version")
    function("${test_set_version}")

        # Create a toolchain object with no user options
        ProjectSpecification(CTOR ps_obj)

        # Create a toolchain object with no user options
        ProjectSpecification(set_version "${ps_obj}" "3.15.5.2-alpha")

        # Get the version variables
        ProjectSpecification(GET "${ps_obj}" _ps
            version
            major_version
            minor_version
            patch_version
            tweak_version
        )

        # Test version variables
        ct_assert_equal(_ps_version "3.15.5.2-alpha")
        ct_assert_equal(_ps_major_version "3")
        ct_assert_equal(_ps_minor_version "15")
        ct_assert_equal(_ps_patch_version "5")
        ct_assert_equal(_ps_tweak_version "2-alpha")

    endfunction()

endfunction()