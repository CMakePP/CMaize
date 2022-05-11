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
            set(tgt_name "test_tgt_ctor_existing_tgt")
            add_custom_target("${tgt_name}")

            Target(CTOR tgt_obj "${tgt_name}")

            Target(GET "${tgt_obj}" result _name)

            ct_assert_equal(result "${tgt_name}")
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

endfunction()
