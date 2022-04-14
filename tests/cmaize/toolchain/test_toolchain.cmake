include(cmake_test/cmake_test)

#[[[
# Test the functionalities of the Toolchain class.
#]]
ct_add_test(NAME "test_toolchain")
function("${test_toolchain}")
    include(cmaize/toolchain/toolchain)

    #[[[
    # Test that the constructor is working with different arguments.
    #]]
    ct_add_section(NAME "constructor")
    function("${constructor}")

        #[[[
        # Test when no toolchain path or content argument is provided.
        # This should give default, autopopulated options for the
        # toolchain options.
        #]]
        ct_add_section(NAME "empty_toolchain")
        function("${empty_toolchain}")

            # Create a toolchain object with no user options
            Toolchain(CTOR toolchain_obj)

            # The file path should be blank
            Toolchain(GET "${toolchain_obj}" my_file_path file_path)
            ct_assert_equal(my_file_path "")

            # Get the map of autopopulated settings
            Toolchain(GET "${toolchain_obj}" auto_pop_map auto_options)
            cpp_serialize(auto_pop_map_serialized "${auto_pop_map}")
            message(">>> Autopopulated map: ${auto_pop_map_serialized}")

            # Toolchain map should be equal to autopopulated options
            Toolchain(GET "${toolchain_obj}" toolchain_map toolchain_options)
            cpp_serialize(toolchain_map_serialized "${toolchain_map}")
            message(">>> Toolchain map: ${toolchain_map_serialized}")
            ct_assert_equal(auto_pop_map_serialized "${toolchain_map_serialized}")
        
        endfunction()

        #[[[
        # Test when a blank string is given for the toolchain path/content
        # argument. This will redirect to ``Toolchain(CTOR self)``, although,
        # in theory, it is supposed to redirect to 
        # ``Toolchain(CTOR self str)``. Either way, it should have the same
        # result and pass.
        #]]
        ct_add_section(NAME "blank_arg")
        function("${blank_arg}")

            # Create a toolchain object with a blank string
            Toolchain(CTOR toolchain_obj "")

            # The file path should be blank
            Toolchain(GET "${toolchain_obj}" my_file_path file_path)
            ct_assert_equal(my_file_path "")

            # Get the map of autopopulated settings
            Toolchain(GET "${toolchain_obj}" auto_pop_map auto_options)
            cpp_serialize(auto_pop_map_serialized "${auto_pop_map}")
            message(">>> Autopopulated map: ${auto_pop_map_serialized}")

            # Toolchain map should be equal to autopopulated options
            Toolchain(GET "${toolchain_obj}" toolchain_map toolchain_options)
            cpp_serialize(toolchain_map_serialized "${toolchain_map}")
            message(">>> Toolchain map: ${toolchain_map_serialized}")
            ct_assert_equal(auto_pop_map_serialized "${toolchain_map_serialized}")
        
        endfunction()

        #[[[
        # Test that the contents of a valid toolchain file can be provided
        # and the object is populated properly.
        #]]
        ct_add_section(NAME "constructor_valid_toolchain")
        function("${constructor_valid_toolchain}")

            #[[[
            # Tests that the autopopulated values are overwritten and that
            # new values are added.
            #]]
            ct_add_section(NAME "toolchain_content_string")
            function("${toolchain_content_string}")

                set(toolchain_contents "# Compilers
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

set(PYTHON_EXECUTABLE python3)
")

                set(corr "{ \"CMAKE_C_COMPILER\" : \"gcc\", \"CMAKE_CXX_COMPILER\" : \"g++\", \"PYTHON_EXECUTABLE\" : \"python3\" }")

                # Create a toolchain object with no user options
                Toolchain(CTOR toolchain_obj "${toolchain_contents}")

                # The file path should be blank
                Toolchain(GET "${toolchain_obj}" my_file_path file_path)
                ct_assert_equal(my_file_path "")

                # Toolchain map should be equal to autopopulated options
                Toolchain(GET "${toolchain_obj}" toolchain_map toolchain_options)
                cpp_serialize(toolchain_map_serialized "${toolchain_map}")
                message(">>> Toolchain map: ${toolchain_map_serialized}")
                ct_assert_equal(corr "${toolchain_map_serialized}")
            
            endfunction()

        endfunction()

    endfunction()

endfunction()
