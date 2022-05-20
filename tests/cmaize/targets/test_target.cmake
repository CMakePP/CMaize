include(cmake_test/cmake_test)

#[[[
# Test the ``Target`` class.
#]]
ct_add_test(NAME "test_tgt")
function("${test_tgt}")
    include(cmaize/targets/target)

    #[[[
    # Test ``Target(CTOR`` method.
    #]]
    ct_add_section(NAME "test_ctor")
    function("${test_ctor}")

        ct_add_section(NAME "test_nonexistant_tgt")
        function("${test_nonexistant_tgt}")
            set(tgt_name "test_tgt_ctor_nonexistant_tgt")

            Target(CTOR tgt_obj "${tgt_name}")

            Target(GET "${tgt_obj}" result _name)

            ct_assert_equal(result "${tgt_name}")
        endfunction()

        ct_add_section(NAME "test_existing_tgt")
        function("${test_existing_tgt}")

            # Create a target
            set(tgt_name "test_tgt_ctor_existing_tgt")
            add_custom_target("${tgt_name}")

            # Set a property
            set(prop_name "test_prop")
            set(prop_value "test_value")
            set_property(
                TARGET "${tgt_name}"
                PROPERTY "${prop_name}" "${prop_value}"
            )

            Target(CTOR tgt_obj "${tgt_name}")

            # Test that the name is correct
            Target(GET "${tgt_obj}" result _name)
            ct_assert_equal(result "${tgt_name}")

            # Test that the property set beforehand still exists with
            # the correct value
            get_target_property(result "${tgt_name}" "${prop_name}")
            ct_assert_equal(result "${prop_value}")
        endfunction()

    endfunction()

    #[[[
    # Test ``Target(target`` method.
    #]]
    ct_add_section(NAME "test_get_target")
    function("${test_get_target}")

        ct_add_section(NAME "nonexistant_tgt")
        function("${nonexistant_tgt}")
            set(tgt_name "test_tgt_get_target_nonexistant_tgt")

            Target(CTOR tgt_obj "${tgt_name}")

            # Explicitly set the _name variable to avoid testing assignment
            # bugs in the CTOR
            Target(SET "${tgt_obj}" _name "${tgt_name}")

            Target(target "${tgt_obj}" result)

            ct_assert_equal(result "${tgt_name}")
        endfunction()

        ct_add_section(NAME "existing_tgt")
        function("${existing_tgt}")
            set(tgt_name "test_tgt_get_target_existing_tgt")
            add_custom_target("${tgt_name}")

            Target(CTOR tgt_obj "${tgt_name}")

            # Explicitly set the _name variable to avoid testing assignment
            # bugs in the CTOR
            Target(SET "${tgt_obj}" _name "${tgt_name}")

            Target(target "${tgt_obj}" result)

            ct_assert_equal(result "${tgt_name}")
        endfunction()

    endfunction()
    
    #[[[
    # Test ``Target(has_property`` method.
    #]]
    ct_add_section(NAME "test_has_property")
    function("${test_has_property}")

        ct_add_section(NAME "invalid_property")
        function("${invalid_property}")

            set(tgt_name "test_tgt_has_property_invalid_property")
            add_custom_target("${tgt_name}")

            Target(CTOR tgt_obj "${tgt_name}")

            Target(has_property "${tgt_obj}" result "invalid_property")

            ct_assert_equal(result FALSE)

        endfunction()

        ct_add_section(NAME "valid_property")
        function("${valid_property}")

            set(tgt_name "test_tgt_has_property_valid_property")
            set(prop_name "test_prop")
            add_custom_target("${tgt_name}")
            set_property(
                TARGET "${tgt_name}"
                PROPERTY "${prop_name}" "test_value"
            )

            Target(CTOR tgt_obj "${tgt_name}")
            
            Target(has_property "${tgt_obj}" result "${prop_name}")

            ct_assert_equal(result TRUE)

        endfunction()

    endfunction()

    #[[[
    # Test ``Target(get_property`` method.
    #]]
    ct_add_section(NAME "test_get_property")
    function("${test_get_property}")

        ct_add_section(NAME "invalid_property" EXPECTFAIL)
        function("${invalid_property}")

            set(tgt_name "test_tgt_get_property_invalid_property")
            add_custom_target("${tgt_name}")

            Target(CTOR tgt_obj "${tgt_name}")

            # Should raise a PropertyNotFound
            Target(get_property "${tgt_obj}" result "invalid_property")

        endfunction()

        ct_add_section(NAME "valid_property")
        function("${valid_property}")

            set(tgt_name "test_tgt_get_property_valid_property")
            set(prop_name "test_prop")
            set(prop_value "test_value")
            add_custom_target("${tgt_name}")
            set_property(
                TARGET "${tgt_name}"
                PROPERTY "${prop_name}" "${prop_value}"
            )

            Target(CTOR tgt_obj "${tgt_name}")

            Target(get_property "${tgt_obj}" result "${prop_name}")

            ct_assert_equal(result "${prop_value}")

        endfunction()

    endfunction()

    #[[[
    # Test ``Target(set_property`` method.
    #]]
    ct_add_section(NAME "test_set_property")
    function("${test_set_property}")

        ct_add_section(NAME "new_property")
        function("${new_property}")

            # Set property name and value to use
            set(prop_name "test_prop")
            set(prop_value "test_value")

            # Create a target 
            set(tgt_name "test_tgt_set_property_new_property")
            add_custom_target("${tgt_name}")

            # Set the property value on the target
            Target(CTOR tgt_obj "${tgt_name}")
            Target(set_property "${tgt_obj}" "${prop_name}" "${prop_value}")

            # Check the property value on the target
            get_target_property(result "${tgt_name}" "${prop_name}")

            ct_assert_equal(result "${prop_value}")

        endfunction()

        ct_add_section(NAME "existing_property")
        function("${existing_property}")

            # Set property name and value to use
            set(prop_name "test_prop")
            set(prop_value "test_value")
            set(prop_value2 "test_value2")
            set(prop_value3 "test_value3")

            # Create a target and set the property beforehand
            set(tgt_name "test_tgt_set_property_existing_property")
            add_custom_target("${tgt_name}")
            set_property(
                TARGET "${tgt_name}"
                PROPERTY "${prop_name}" "${prop_value}"
            )

            # Set the property again in the Target object
            Target(CTOR tgt_obj "${tgt_name}")
            Target(set_property "${tgt_obj}" "${prop_name}" "${prop_value2}")

            get_target_property(result "${tgt_name}" "${prop_name}")
            ct_assert_equal(result "${prop_value2}")

            # This will overwrite the value that the Target object just
            # overwrote above
            Target(set_property "${tgt_obj}" "${prop_name}" "${prop_value3}")

            get_target_property(result "${tgt_name}" "${prop_name}")
            ct_assert_equal(result "${prop_value3}")

        endfunction()

    endfunction()

    #[[[
    # Test ``Target(set_properties`` method.
    #]]
    ct_add_section(NAME "test_set_properties")
    function("${test_set_properties}")

        ct_add_section(NAME "new_properties")
        function("${new_properties}")

            # Set property name and value to use
            cpp_map(CTOR
                property_map
                test_name_1 "test_value_1"
                test_name_2 "test_value_2"
            )

            # Create a target 
            set(tgt_name "test_tgt_set_properties_new_properties")
            add_custom_target("${tgt_name}")

            # Set the property value on the target
            Target(CTOR tgt_obj "${tgt_name}")
            Target(set_properties "${tgt_obj}" "${property_map}")

            # Check the property value on the target
            get_target_property(result_1 "${tgt_name}" "test_name_1")
            get_target_property(result_2 "${tgt_name}" "test_name_2")

            ct_assert_equal(result_1 "test_value_1")
            ct_assert_equal(result_2 "test_value_2")

        endfunction()

        ct_add_section(NAME "existing_properties")
        function("${existing_properties}")

            # Set property name and value to use
            cpp_map(CTOR
                property_map
                test_name_1 "test_value_1"
                test_name_2 "test_value_2"
            )

            # Create a target and add the properties
            set(tgt_name "test_tgt_set_properties_existing_properties")
            add_custom_target("${tgt_name}")
            set_target_properties("${tgt_name}"
                PROPERTIES
                    test_name_1 "original_value_1"
                    test_name_2 "original_value_2"
            )

            # Set the property value on the target
            Target(CTOR tgt_obj "${tgt_name}")
            Target(set_properties "${tgt_obj}" "${property_map}")

            # Check the property value on the target
            get_target_property(result_1 "${tgt_name}" "test_name_1")
            get_target_property(result_2 "${tgt_name}" "test_name_2")

            ct_assert_equal(result_1 "test_value_1")
            ct_assert_equal(result_2 "test_value_2")

        endfunction()

    endfunction()

endfunction()
