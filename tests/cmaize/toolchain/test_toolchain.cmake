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
# Test the functionalities of the Toolchain class.
#]]
ct_add_test(NAME "test_toolchain")
function("${test_toolchain}")
    include(cmaize/toolchain/toolchain)

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
            Toolchain(CTOR toolchain_obj)

            # The file content should be blank
            Toolchain(GET "${toolchain_obj}" file_contents encoded_toolchain_contents)
            ct_assert_equal(file_contents "")

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

            # The file content should be blank
            Toolchain(GET "${toolchain_obj}" file_contents encoded_toolchain_contents)
            ct_assert_equal(file_contents "")

        endfunction()

        #[[[
        # Test that the contents of a valid toolchain file can be provided
        # and the object is populated properly.
        #]]
        ct_add_section(NAME "valid_toolchain")
        function("${valid_toolchain}")

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
string(APPEND\n test_string \n\"a st\nring\")"
            )

            cpp_encode_special_chars("${toolchain_contents}" encoded_toolchain)

            # Create a toolchain object with the toolchain contents
            Toolchain(CTOR toolchain_obj "${toolchain_contents}")

            # The file content should match
            Toolchain(GET "${toolchain_obj}" file_contents encoded_toolchain_contents)
            ct_assert_equal(encoded_toolchain "${file_contents}")

        endfunction()

    endfunction()

    ct_add_section(NAME "test_generate_file_contents")
    function("${test_generate_file_contents}")

        set(toolchain_contents "set(CMAKE_C_COMPILER    gcc)
set(
    MPI_CXX_COMPILER
    /opt/openmpi-4.1.2/bin/mpicxx
)
set(unique_variable test)"
        )

        # Create a toolchain object with the toolchain contents
        Toolchain(CTOR toolchain_obj "${toolchain_contents}")

        Toolchain(generate_file_contents "${toolchain_obj}" file_contents)

        # Check for a few key phrases

        # Autopopulated options header
        message("${file_contents}")
        ct_assert_prints("# CMaize Autopopulated Options")

        # CMAKE_CXX_COMPILER only set in autopopulated options
        message("${file_contents}")
        ct_assert_prints("CMAKE_CXX_COMPILER")

        # User toolchain header
        message("${file_contents}")
        ct_assert_prints("# User Toolchain")

        # unique_variable only in 
        message("${file_contents}")
        ct_assert_prints("unique_variable")

    endfunction()

endfunction()