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

include_guard()
include(cmakepp_lang/cmakepp_lang)

include(cmaize/toolchain/toolchain)
include(cmaize/utilities/utilities)

#[[[
# The ``PackageSpecification`` class is envisioned as holding all of the
# details about how to build a package ("package" being a catchall for a
# dependency or the project that the CMaize build system is being written
# for). This includes things like where the source code lives, the version
# to build, and specific options for configuring and compiling.
# ``PackageSpecification`` instances will ultimately be used to request
# packages from the ``PackageManager``.
#]]
cpp_class(PackageSpecification)

    #[[[
    # :type: str
    #
    # Name of package as a string.
    #]]
    cpp_attr(PackageSpecification name)

    #[[[
    # :type: str
    #
    # Version of package as a string.
    #]]
    cpp_attr(PackageSpecification version)

    #[[[
    # :type: str
    #
    # First version number component of the ``version`` attribute.
    #]]
    cpp_attr(PackageSpecification major_version)

    #[[[
    # :type: str
    #
    # Second version number component of the ``version`` attribute.
    #]]
    cpp_attr(PackageSpecification minor_version)

    #[[[
    # :type: str
    #
    # Third version number component of the ``version`` attribute.
    #]]
    cpp_attr(PackageSpecification patch_version)

    #[[[
    # :type: str
    #
    # Fourth version number component of the ``version`` attribute.
    #]]
    cpp_attr(PackageSpecification tweak_version)

    #[[[
    # :type: str
    #
    # Specifies the build type.
    #
    # For the possible values provided by CMake and how to add custom build
    # types, see `CMAKE_BUILD_TYPE
    # <https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html>`__.
    #
    # .. note::
    #
    #    Currently, only single-configuration generators are supported since
    #    the ``build_type`` is based on ``CMAKE_BUILD_TYPE``. This could be
    #    expanded to multi-configuration generators later, although the
    #    build type will need to be determined at build time instead of
    #    configure time. See `CMAKE_CONFIGURATION_TYPES
    #    <https://cmake.org/cmake/help/latest/variable/CMAKE_CONFIGURATION_TYPES.html#variable:CMAKE_CONFIGURATION_TYPES>`__
    #    and `CMake Build Configurations
    #    <https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#build-configurations>`__
    #    for more information on the details of making this switch.
    #]]
    cpp_attr(PackageSpecification build_type)

    #[[[
    # :type: Toolchain
    #
    # User-specified and autopopulated toolchain file values.
    #]]
    cpp_attr(PackageSpecification toolchain)

    #[[[
    # :type: cpp_map
    #
    # The options in this map control which variant of a package is requested.
    # They are package-specific options and are usually along the lines of
    # "ENABLE_XXX" and the like. More traditional CMake options like
    # "BUILD_SHARED_LIBS" should be part of the toolchain.
    #
    # This is initialized to an empty map for users to fill.
    #]]
    cpp_attr(PackageSpecification configure_options)

    #[[[
    # :type: cpp_map
    #
    # Package compile options.
    #
    # This is initialized to an empty map for users to fill.
    #]]
    cpp_attr(PackageSpecification compile_options)

    #[[[
    # Default constructor for PackageSpecification object with only
    # autopopulated options available.
    #
    # :param self: PackageSpecification object constructed.
    # :type self: PackageSpecification
    # :returns: ``self`` will be set to the newly constructed
    #           ``PackageSpecification`` object.
    # :rtype: PackageSpecification
    #]]
    cpp_constructor(CTOR PackageSpecification)
    function("${CTOR}" self)

        # Initialize the PackageSpecification object
        PackageSpecification(__initialize "${self}")

    endfunction()

    #[[[
    # Hash the object using the provided hashing algorithm string.
    #
    # Supported hashing algorithms are specified by the CMake
    # ``string(<HASH>`` function defined `here
    # <https://cmake.org/cmake/help/latest/command/string.html#hashing>`__.
    #
    # :param self: ``PackageSpecification`` object to hash.
    # :type self: PackageSpecification
    # :param return_hash: Hashed ``PackageSpecification``
    # :type return_hash: str
    # :param hash_type: Hash algorithm to use
    # :type hash_type: str
    #
    # :returns: Hashed ``PackageSpecification`` object
    # :rtype: str
    #]]
    cpp_member(hash PackageSpecification str str)
    function("${hash}" self return_hash hash_type)

        cpp_serialize(self_serialized "${self}")

        string("${hash_type}" "${return_hash}" "${self_serialized}")

        cpp_return("${return_hash}")

    endfunction()

    #[[[
    # Overload to ``set_version()`` method to catch when the package version
    # string is blank.
    #
    # .. note::
    #
    #    This override is required because of a bug in CMakePPLang.
    #    Currently, CMakePPLang cannot differentiate between
    #    ``PackageSpecification(set_version "${ps_obj}")`` and
    #    ``PackageSpecification(set_version "${ps_obj}" "")``. Sometimes the
    #    ``PROJECT_VERSION`` variable used in ``__initialize`` to determine
    #    a default package version is blank, so this ensures we do not get
    #    an error about not including the version argument for
    #    ``cpp_member(set_version PackageSpecification str)`` calls.
    #
    # :param self: ``PackageSpecification`` object.
    # :type self: PackageSpecification
    #]]
    cpp_member(set_version PackageSpecification)
    function("${set_version}" self)

        PackageSpecification(SET "${self}" version "")
        PackageSpecification(SET "${self}" major_version "")
        PackageSpecification(SET "${self}" minor_version "")
        PackageSpecification(SET "${self}" patch_version "")
        PackageSpecification(SET "${self}" tweak_version "")

    endfunction()

    #[[[
    # Registers a configuration option with self.
    #
    # This method is a convenience function for getting the internal map of
    # configuration options and updating it with the user supplied option and
    # value.
    #
    # :param self: ``PackageSpecification`` object.
    # :type self: PackageSpecification
    # :param name: The name of the configuration option
    # :type name: desc
    # :param value: The value for the option.
    # :type value: str
    #]]
    cpp_member(set_config_option PackageSpecification desc str)
    function("${set_config_option}" self _sco_name _sco_value)

        PackageSpecification(GET "${self}" _sco_options configure_options)
        cpp_map(SET "${_sco_options}" "${_sco_name}" "${_sco_value}")

    endfunction()

    #[[[
    # Retrieves a configuration option from self.
    #
    # This method is a convenience function for getting the value of a
    # configuration option from the internal map of configuration options.
    #
    # :param self: ``PackageSpecification`` object.
    # :type self: PackageSpecification
    # :param value: The value of the requested option.
    # :type value: str
    # :param name: The name of the configuration option
    # :type name: desc
    #
    # :raises KeyError: If ``name`` is not a configuration option which has been
    #                   added via ``set_config_option``. Strong throw guarantee.
    #]]
    cpp_member(get_config_option PackageSpecification str desc)
    function("${get_config_option}" self _gco_value _gco_name)

        PackageSpecification(GET "${self}" _gco_options configure_options)
        cpp_map(HAS_KEY "${_gco_options}" _gco_has_key "${_gco_name}")
        if(NOT ${_gco_has_key})
            cpp_raise(KeyError "No configuration option: ${_gco_name}")
        endif()

        cpp_map(GET "${_gco_options}" "${_gco_value}" "${_gco_name}")
        cpp_return("${_gco_value}")

    endfunction()

    #[[[
    # Determines if a configuration option was added to self.
    #
    # This method is a convenience function for getting the internal map of
    # configuration options and if the user set a specified key. If the user
    # set ``name``, ``result`` will be set to true; otherwise, ``result`` will
    # be false.
    #
    # :param self: ``PackageSpecification`` object.
    # :type self: PackageSpecification
    # :param result: The identifier to assign the result to.
    # :type result: bool*
    # :param name: The name of the configuration option
    # :type name: desc
    #]]
    cpp_member(has_config_option PackageSpecification bool* desc)
    function("${has_config_option}" self _hco_result _hco_name)

        PackageSpecification(GET "${self}" _hco_options configure_options)
        cpp_map(HAS_KEY "${_hco_options}" "${_hco_result}" "${_hco_name}")
        cpp_return("${_hco_result}")

    endfunction()

    #[[[
    # Set the package version variable and splits the version into
    # major, minor, patch, and tweak components.
    #
    # :param self: ``PackageSpecification`` object.
    # :type self: PackageSpecification
    # :param package_version: Full package version string.
    # :type package_version: str
    #]]
    cpp_member(set_version PackageSpecification str)
    function("${set_version}" self package_version)

        cmaize_split_version(major minor patch tweak "${package_version}")

        PackageSpecification(SET "${self}" version "${package_version}")
        PackageSpecification(SET "${self}" major_version "${major}")
        PackageSpecification(SET "${self}" minor_version "${minor}")
        PackageSpecification(SET "${self}" patch_version "${patch}")
        PackageSpecification(SET "${self}" tweak_version "${tweak}")

    endfunction()

    #[[[
    # Initialize package attributes with default values.
    #
    # :param self: ``PackageSpecification`` object to initialize.
    # :type self: PackageSpecification
    #]]
    cpp_member(__initialize PackageSpecification)
    function("${__initialize}" self)

        # Get the name from the most recent ``project()`` call
        PackageSpecification(SET "${self}" name "${PROJECT_NAME}")

        # Get the version from the most recent ``project()`` call
        PackageSpecification(set_version "${self}" "${PROJECT_VERSION}")

        PackageSpecification(SET "${self}" build_type "${CMAKE_BUILD_TYPE}")

        # Initialize toolchain using CMAKE_TOOLCHAIN_FILE variable
        Toolchain(CTOR my_toolchain "${CMAKE_TOOLCHAIN_FILE}")
        PackageSpecification(SET "${self}" toolchain "${my_toolchain}")

        # Set the configure_options map to an empty map
        cpp_map(CTOR tmp_configure_options)
        Toolchain(SET "${self}" configure_options "${tmp_configure_options}")

        # Set the compile_options map to an empty map
        cpp_map(CTOR tmp_compile_options)
        Toolchain(SET "${self}" compile_options "${tmp_compile_options}")

    endfunction()

cpp_end_class()
