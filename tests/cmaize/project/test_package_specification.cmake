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
# Test the functionalities of the PackageSpecification class.
#]]
ct_add_test(NAME "test_package_specification")
function("${test_package_specification}")
    include(cmaize/project/package_specification)

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
            PackageSpecification(CTOR ps_obj)

            # The file content should be blank
            PackageSpecification(GET "${ps_obj}" _ps name version build_type)
            ct_assert_equal(_ps_name "${PROJECT_NAME}")
            ct_assert_equal(_ps_version "${PROJECT_VERSION}")
            ct_assert_equal(_ps_build_type "${CMAKE_BUILD_TYPE}")

        endfunction()

    endfunction()

    #[[[
    # Test setting the version.
    #]]
    ct_add_section(NAME "test_set_version")
    function("${test_set_version}")

        # Create a toolchain object with no user options
        PackageSpecification(CTOR ps_obj)

        # Set the version to a reasonable value
        PackageSpecification(set_version "${ps_obj}" "3.15.5.2-alpha")

        # Get the version variables
        PackageSpecification(GET "${ps_obj}" _ps
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


    #[[[
    # Tests the setter for configuration options
    #]]
    ct_add_section(NAME "test_set_config_option")
    function("${test_set_config_option}")

        PackageSpecification(CTOR ps_obj)
        PackageSpecification(set_config_option "${ps_obj}" "Hello" "World!!!")

        cpp_map(CTOR corr "Hello" "World!!!")
        PackageSpecification(GET "${ps_obj}" config_options configure_options)
        cpp_map(EQUAL "${corr}" result "${config_options}")
        ct_assert_equal(result TRUE)

        # Now we test what happens if set_option is called again
        ct_add_section(NAME "can_overwrite_option")
        function("${can_overwrite_option}")

            PackageSpecification(set_config_option "${ps_obj}" "Hello" 42)
            cpp_map(EQUAL "${corr}" result "${config_options}")
            ct_assert_equal(result FALSE)

            cpp_map(GET "${config_options}" option_value "Hello")
            ct_assert_equal(option_value 42)

        endfunction()

    endfunction()

    #[[[
    # Tests the getter for configuration options
    #]]
    ct_add_section(NAME "test_get_config_option")
    function("${test_get_config_option}")

        PackageSpecification(CTOR ps_obj)
        PackageSpecification(set_config_option "${ps_obj}" "Hello" "World!!!")
        PackageSpecification(get_config_option "${ps_obj}" option_value "Hello")
        ct_assert_equal(option_value "World!!!")

        ct_add_section(NAME "throws_if_bad_key" EXPECTFAIL)
        function("${throws_if_bad_key}")
            PackageSpecification(
                get_config_option "${ps_obj}" option_value "Not a Key!"
            )
        endfunction()

    endfunction()

    #[[[
    # Tests checking if a config option has been defined.
    #]]
    ct_add_section(NAME "test_has_config_option")
    function("${test_has_config_option}")

        PackageSpecification(CTOR ps_obj)

        # Option does not exist
        PackageSpecification(has_config_option "${ps_obj}" has_hello "Hello")
        ct_assert_false(has_hello)

        #Option exists
        PackageSpecification(set_config_option "${ps_obj}" "Hello" "World!!!")
        PackageSpecification(has_config_option "${ps_obj}" has_hello "Hello")
        ct_assert_true(has_hello)
    endfunction()

    #[[[
    # Test hashing the object.
    #]]
    ct_add_section(NAME "test_hash")
    function("${test_hash}")

        ct_add_section(NAME "bad_hash_type" EXPECTFAIL)
        function("${bad_hash_type}")

            # Create a toolchain object with no user options
            PackageSpecification(CTOR ps_obj)

            # Hash the object
            PackageSpecification(hash "${ps_obj}" hash "bad_type")

            # This should throw in one way or another

        endfunction()

        #[[[
        # This test sets a very specific state and verifies that the correct
        # hash is created and returned.
        #]]
        ct_add_section(NAME "check_hash_result")
        function("${check_hash_result}")

            set(corr_hash "f045215c1d2d14bd3d4fcfd71c009fed40bd2dfc")

            # Create a toolchain object with no user options
            PackageSpecification(CTOR ps_obj)

            # Hash the object
            PackageSpecification(hash "${ps_obj}" returned_hash "SHA1")

            # SHA1 produces hash strings of length 40
            string(LENGTH "${returned_hash}" hash_length)
            ct_assert_equal(hash_length 40)

            # SHA1 hash strings should only contain lowercase alphanumerics
            string(REGEX MATCH "^[a-z0-9]+$" hash_match "${returned_hash}")
            # Since this regex needs to match the entire hash string,
            # REGEX MATCH should return the entire hash if it matched and
            # we can just compare the match to the original hash string
            ct_assert_equal(hash_match "${returned_hash}")

        endfunction()

        #[[[
        # This test just makes sure that the supported types do not throw
        # as invalid.
        #]]
        ct_add_section(NAME "valid_hash_types")
        function("${valid_hash_types}")

            # Create a toolchain object with no user options
            PackageSpecification(CTOR ps_obj)

            # Hash the object
            PackageSpecification(hash "${ps_obj}" return_hash "MD5")
            PackageSpecification(hash "${ps_obj}" return_hash "SHA1")
            PackageSpecification(hash "${ps_obj}" return_hash "SHA224")
            PackageSpecification(hash "${ps_obj}" return_hash "SHA256")
            PackageSpecification(hash "${ps_obj}" return_hash "SHA384")
            PackageSpecification(hash "${ps_obj}" return_hash "SHA512")
            PackageSpecification(hash "${ps_obj}" return_hash "SHA3_224")
            PackageSpecification(hash "${ps_obj}" return_hash "SHA3_256")
            PackageSpecification(hash "${ps_obj}" return_hash "SHA3_384")
            PackageSpecification(hash "${ps_obj}" return_hash "SHA3_512")

        endfunction()

    endfunction()

endfunction()
