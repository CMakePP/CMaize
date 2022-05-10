include(cmake_test/cmake_test)

#[[[
# Test the ``Target`` class.
#]]
ct_add_test(NAME "test_target")
function("${test_target}")
    include(cmaize/targets/target)

    # #[[[
    # # Test that the constructor is working with different arguments.
    # #]]
    # ct_add_section(NAME "test_constructor")
    # function("${test_constructor}")

    #     #[[[
    #     # Test that the default constructor works.
    #     #]]
    #     ct_add_section(NAME "default_ctor")
    #     function("${default_ctor}")

    #         # Create a toolchain object with no user options
    #         Target(CTOR tgt_obj)

    #         # Everything should be blank
    #         ProjectSpecification(GET "${tgt_obj}" _tgt _properties _target)
    #         ct_assert_equal(_ps_name "${PROJECT_NAME}")
    #         ct_assert_equal(_ps_version "${PROJECT_VERSION}")
    #         ct_assert_equal(_ps_build_type "${CMAKE_BUILD_TYPE}")

    #     endfunction()

    # endfunction()

    #[[[
    # Test ``Target.has_property()`` method.
    #]]
    ct_add_section(NAME "test_has_property")
    function("${test_has_property}")

        ct_add_section(NAME "invalid_property")
        function("${invalid_property}")

            Target(CTOR tgt_obj)

            Target(has_property "${tgt_obj}" result "invalid_property")

            ct_assert_equal(result FALSE)

        endfunction()

        ct_add_section(NAME "valid_property")
        function("${valid_property}")

            Target(CTOR tgt_obj)

            # Add a property to the target
            Target(GET "${tgt_obj}" tgt_properties _properties)
            cpp_map(APPEND "${tgt_properties}" "test_property" "test_value")
            Target(SET "${tgt_obj}" _properties "${tgt_properties}")
            
            Target(has_property "${tgt_obj}" result "test_property")

            ct_assert_equal(result TRUE)

        endfunction()

    endfunction()

    #[[[
    # Test ``Target.get_property()`` method.
    #]]
    ct_add_section(NAME "test_has_properties")
    function("${test_has_properties}")

        ct_add_section(NAME "invalid_property" EXPECTFAIL)
        function("${invalid_property}")

            Target(CTOR tgt_obj)

            # Should raise a PropertyNotFound
            Target(get_property "${tgt_obj}" result "invalid_property")

        endfunction()

        ct_add_section(NAME "valid_property")
        function("${valid_property}")

            set(corr_value "test_value")

            Target(CTOR tgt_obj)

            # Add a property to the target
            Target(GET "${tgt_obj}" tgt_properties _properties)
            cpp_map(APPEND "${tgt_properties}" "test_property" "${corr_value}")
            Target(SET "${tgt_obj}" _properties "${tgt_properties}")
            
            Target(get_property "${tgt_obj}" result "test_property")

            ct_assert_equal(result "${corr_value}")

        endfunction()

    endfunction()

endfunction()