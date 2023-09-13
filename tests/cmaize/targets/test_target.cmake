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
# Test the ``CMaizeTarget`` class.
#]]
ct_add_test(NAME "test_tgt")
function("${test_tgt}")
    include(cmaize/targets/cmaize_target)

    #[[[
    # Test ``CMaizeTarget(CTOR`` method.
    #]]
    ct_add_section(NAME "test_ctor")
    function("${test_ctor}")

        ct_add_section(NAME "test_nonexistant_tgt")
        function("${test_nonexistant_tgt}")
            set(tgt_name "test_tgt_ctor_nonexistant_tgt")

            CMaizeTarget(CTOR tgt_obj "${tgt_name}")

            CMaizeTarget(GET "${tgt_obj}" result _name)

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

            CMaizeTarget(CTOR tgt_obj "${tgt_name}")

            # Test that the name is correct
            CMaizeTarget(GET "${tgt_obj}" result _name)
            ct_assert_equal(result "${tgt_name}")

            # Test that the property set beforehand still exists with
            # the correct value
            get_target_property(result "${tgt_name}" "${prop_name}")
            ct_assert_equal(result "${prop_value}")
        endfunction()

    endfunction()

    #[[[
    # Test ``CMaizeTarget(target`` method.
    #]]
    ct_add_section(NAME "test_get_target")
    function("${test_get_target}")

        ct_add_section(NAME "nonexistant_tgt")
        function("${nonexistant_tgt}")
            set(tgt_name "test_tgt_get_target_nonexistant_tgt")

            CMaizeTarget(CTOR tgt_obj "${tgt_name}")

            # Explicitly set the _name variable to avoid testing assignment
            # bugs in the CTOR
            CMaizeTarget(SET "${tgt_obj}" _name "${tgt_name}")

            CMaizeTarget(target "${tgt_obj}" result)

            ct_assert_equal(result "${tgt_name}")
        endfunction()

        ct_add_section(NAME "existing_tgt")
        function("${existing_tgt}")
            set(tgt_name "test_tgt_get_target_existing_tgt")
            add_custom_target("${tgt_name}")

            CMaizeTarget(CTOR tgt_obj "${tgt_name}")

            # Explicitly set the _name variable to avoid testing assignment
            # bugs in the CTOR
            CMaizeTarget(SET "${tgt_obj}" _name "${tgt_name}")

            CMaizeTarget(target "${tgt_obj}" result)

            ct_assert_equal(result "${tgt_name}")
        endfunction()

    endfunction()
    
    #[[[
    # Test ``CMaizeTarget(has_property`` method.
    #]]
    ct_add_section(NAME "test_has_property")
    function("${test_has_property}")

        ct_add_section(NAME "invalid_property")
        function("${invalid_property}")

            set(tgt_name "test_tgt_has_property_invalid_property")
            add_custom_target("${tgt_name}")

            CMaizeTarget(CTOR tgt_obj "${tgt_name}")

            CMaizeTarget(has_property "${tgt_obj}" result "invalid_property")

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

            CMaizeTarget(CTOR tgt_obj "${tgt_name}")
            
            CMaizeTarget(has_property "${tgt_obj}" result "${prop_name}")

            ct_assert_equal(result TRUE)

        endfunction()

    endfunction()

    #[[[
    # Test ``CMaizeTarget(get_property`` method.
    #]]
    ct_add_section(NAME "test_get_property")
    function("${test_get_property}")

        ct_add_section(NAME "invalid_property" EXPECTFAIL)
        function("${invalid_property}")

            set(tgt_name "test_tgt_get_property_invalid_property")
            add_custom_target("${tgt_name}")

            CMaizeTarget(CTOR tgt_obj "${tgt_name}")

            # Should raise a PropertyNotFound
            CMaizeTarget(get_property "${tgt_obj}" result "invalid_property")

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

            CMaizeTarget(CTOR tgt_obj "${tgt_name}")

            CMaizeTarget(get_property "${tgt_obj}" result "${prop_name}")

            ct_assert_equal(result "${prop_value}")

        endfunction()

    endfunction()

    #[[[
    # Test ``CMaizeTarget(set_property`` method.
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
            CMaizeTarget(CTOR tgt_obj "${tgt_name}")
            CMaizeTarget(set_property "${tgt_obj}" "${prop_name}" "${prop_value}")

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

            # Set the property again in the CMaizeTarget object
            CMaizeTarget(CTOR tgt_obj "${tgt_name}")
            CMaizeTarget(set_property "${tgt_obj}" "${prop_name}" "${prop_value2}")

            get_target_property(result "${tgt_name}" "${prop_name}")
            ct_assert_equal(result "${prop_value2}")

            # This will overwrite the value that the CMaizeTarget object just
            # overwrote above
            CMaizeTarget(set_property "${tgt_obj}" "${prop_name}" "${prop_value3}")

            get_target_property(result "${tgt_name}" "${prop_name}")
            ct_assert_equal(result "${prop_value3}")

        endfunction()

    endfunction()

    #[[[
    # Test ``CMaizeTarget(set_properties`` method.
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
            CMaizeTarget(CTOR tgt_obj "${tgt_name}")
            CMaizeTarget(set_properties "${tgt_obj}" "${property_map}")

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
            CMaizeTarget(CTOR tgt_obj "${tgt_name}")
            CMaizeTarget(set_properties "${tgt_obj}" "${property_map}")

            # Check the property value on the target
            get_target_property(result_1 "${tgt_name}" "test_name_1")
            get_target_property(result_2 "${tgt_name}" "test_name_2")

            ct_assert_equal(result_1 "test_value_1")
            ct_assert_equal(result_2 "test_value_2")

        endfunction()

    endfunction()

endfunction()
