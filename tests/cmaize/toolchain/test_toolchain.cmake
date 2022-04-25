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
            # Tests that a ``set()`` command is parsed properly.
            #]]
            ct_add_section(NAME "set_cmd")
            function("${set_cmd}")

                ct_add_section(NAME "single_line")
                function("${single_line}")

                    set(toolchain_contents "set(CMAKE_C_COMPILER test_compiler)")

                    set(corr "test_compiler")

                    # Create a toolchain object
                    Toolchain(CTOR toolchain_obj "${toolchain_contents}")

                    # Test that the toolchain map key changed accordingly
                    Toolchain(GET "${toolchain_obj}" toolchain_map toolchain_options)
                    cpp_map(GET "${toolchain_map}" value "CMAKE_C_COMPILER")
                    message(">>> CMAKE_C_COMPILER: ${value}")
                    ct_assert_equal(corr "${value}")

                endfunction()

                ct_add_section(NAME "multi_line")
                function("${multi_line}")

                    set(toolchain_contents "set(\nCMAKE_C_COMPILER \ntest_compiler\n)")

                    set(corr "test_compiler")

                    # Create a toolchain object
                    Toolchain(CTOR toolchain_obj "${toolchain_contents}")

                    # Test that the toolchain map key changed accordingly
                    Toolchain(GET "${toolchain_obj}" toolchain_map toolchain_options)
                    cpp_map(GET "${toolchain_map}" value "CMAKE_C_COMPILER")
                    message(">>> CMAKE_C_COMPILER: ${value}")
                    ct_assert_equal(corr "${value}")
                    
                endfunction()
            
            endfunction()

            #[[[
            # Tests that a ``list(APPEND`` command is parsed properly.
            #]]
            ct_add_section(NAME "list_append_cmd")
            function("${list_append_cmd}")

                set(toolchain_contents "list(APPEND test_prefix_path /usr/lib)\n")
                string(APPEND toolchain_contents "list(APPEND test_prefix_path /usr/bin)")
                
                set(corr "/usr/lib;/usr/bin")

                # Create a toolchain object
                Toolchain(CTOR toolchain_obj "${toolchain_contents}")

                # Test that the toolchain map key changed accordingly
                Toolchain(GET "${toolchain_obj}" toolchain_map toolchain_options)
                cpp_map(GET "${toolchain_map}" value "test_prefix_path")
                message(">>> test_prefix_path: ${value}")
                ct_assert_equal(corr "${value}")
            
            endfunction()

            #[[[
            # Tests that a ``string(APPEND`` command is parsed properly.
            #]]
            ct_add_section(NAME "string_append_cmd")
            function("${string_append_cmd}")

                ct_add_section(NAME "single_line")
                function("${single_line}")

                    set(toolchain_contents "string(APPEND test_string \"a string\")\n")
                    string(APPEND toolchain_contents "string(APPEND test_string \" with more appended\")")
                    
                    set(corr "a string with more appended")

                    # Create a toolchain object
                    Toolchain(CTOR toolchain_obj "${toolchain_contents}")

                    # Test that the toolchain map key changed accordingly
                    Toolchain(GET "${toolchain_obj}" toolchain_map toolchain_options)
                    cpp_map(GET "${toolchain_map}" value "test_string")
                    message(">>> test_string: ${value}")
                    ct_assert_equal(corr "${value}")

                endfunction()

                ct_add_section(NAME "multi_line")
                function("${multi_line}")

                    set(toolchain_contents "string(APPEND\n test_string \n\"a st\nring\")\n")
                    string(APPEND toolchain_contents "string(APPEND test_string \" with more appended\"\n)")
                    
                    set(corr "a st ring with more appended")

                    # Create a toolchain object
                    Toolchain(CTOR toolchain_obj "${toolchain_contents}")

                    # Test that the toolchain map key changed accordingly
                    Toolchain(GET "${toolchain_obj}" toolchain_map toolchain_options)
                    cpp_map(GET "${toolchain_map}" value "test_string")
                    message(">>> test_string: ${value}")
                    ct_assert_equal(corr "${value}")

                endfunction()
            
            endfunction()

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

    #[[[
    # Test creating a string for ``CMAKE_ARGS``.
    #]]
    ct_add_section(NAME "test_as_cmake_args")
    function("${test_as_cmake_args}")
        # include for cpp_decode_special_chars
        include(cmakepp_lang/cmakepp_lang)

#         set(toolchain_contents "# Compilers
# set(CMAKE_C_COMPILER gcc)
# set(CMAKE_CXX_COMPILER g++)

# set(PYTHON_EXECUTABLE python3)
# ")

        set(toolchain_contents "set(CMAKE_C_COMPILER    gcc)
set(
    MPI_CXX_COMPILER
    /opt/openmpi-4.1.2/bin/mpicxx
)
set(
    MPI_C_COMPILER /opt/openmpi-4.1.2/bin/mpicc

)
set(FETCHCONTENT_SOURCE_DIR_CHEMCACHE /home/zachcran/programs/chemcache)
# set(FETCHCONTENT_SOURCE_DIR_BPHASH /home/zachcran/programs/bphash/bphash)
list(APPEND CMAKE_PREFIX_PATH /usr/bin)
list(APPEND CMAKE_PREFIX_PATH /usr/lib)
string(APPEND 
    CMAKE_CXX_FLAGS 
\" -GNinja\")
string(APPEND\n test_string \n\"a st\nring\")")

        set(corr "-DCMAKE_C_COMPILER=\"gcc\" -DCMAKE_CXX_COMPILER=\"\" -DMPI_CXX_COMPILER=\"/opt/openmpi-4.1.2/bin/mpicxx\" -DMPI_C_COMPILER=\"/opt/openmpi-4.1.2/bin/mpicc\" -DFETCHCONTENT_SOURCE_DIR_CHEMCACHE=\"/home/zachcran/programs/chemcache\" -DCMAKE_PREFIX_PATH=\"/usr/bin\;/usr/lib\" -DCMAKE_CXX_FLAGS=\"-GNinja\" -Dtest_string=\"a st ring\"")
        cpp_encode_special_chars("${corr}" corr)

        # Create a toolchain object with no user options
        Toolchain(CTOR toolchain_obj "${toolchain_contents}")

        # The file path should be blank
        Toolchain(GET "${toolchain_obj}" my_file_path file_path)
        ct_assert_equal(my_file_path "")

        # Toolchain map should be equal to autopopulated options
        Toolchain(as_cmake_args "${toolchain_obj}" encoded_toolchain_args)

        message(">>> Toolchain args: ${encoded_toolchain_args}")

        ct_assert_equal(corr "${encoded_toolchain_args}")

    endfunction()

endfunction()
