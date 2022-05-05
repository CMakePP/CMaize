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
            ProjectSpecification(GET "${ps_obj}" ps_build_type build_type)
            ct_assert_equal(ps_build_type "${CMAKE_BUILD_TYPE}")

        endfunction()

    endfunction()

endfunction()