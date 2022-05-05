include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/toolchain/toolchain)

#[[[
# The ``ProjectSpecification`` class is envisioned as holding all of the
# details about how to build a project (project being a catchall for a
# dependency or the project the CMaize build system is actually being written
# for). This includes things like where the source code lives, the version
# to build, specific options for configuring, etc. ``ProjectSpecification``
# instances will ultimately be used to request packages from the
# ``PackageManager``.
#]]
cpp_class(ProjectSpecification)
    
    #[[[
    # Name of project or dependency as a string.
    #]]
    cpp_attr(ProjectSpecification name)

    #[[[
    # Version of project or dependency as a string.
    #]]
    cpp_attr(ProjectSpecification version)

    #[[[
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
    cpp_attr(ProjectSpecification build_type)

    #[[[
    # CMaize ``Toolchain`` object.
    #]]
    cpp_attr(ProjectSpecification toolchain)

    cpp_attr(ProjectSpecification configure_options)
    cpp_attr(ProjectSpecification compile_options)

    #[[[
    # Default constructor for ProjectSpecification object with only
    # autopopulated options available.
    #
    # :param self: ProjectSpecification object constructed.
    # :type self: ProjectSpecification
    # :returns: ``self`` will be set to the newly constructed
    #           ``ProjectSpecification`` object.
    # :rtype: ProjectSpecification
    #]]
    cpp_constructor(CTOR ProjectSpecification)
    function("${CTOR}" self)

        # Initialize the ProjectSpecification object
        ProjectSpecification(__initialize "${self}")

    endfunction()

    #[[[
    # Placeholder for hash function.
    #
    # :param self: ``ProjectSpecification`` object to hash.
    # :type self: ProjectSpecification
    # :param return_hash: Hashed ``ProjectSpecification``
    # :type return_hash: str
    # :returns: Hashed ``ProjectSpecification`` object
    # :rtype: str
    #]]
    cpp_member(hash ProjectSpecification str)
    function("${hash}" self return_hash)

        message("-- Called ProjectSpecification.hash() member")

    endfunction()

    #[[[
    # Initialize project attributes with default values.
    #
    # :param self: ``ProjectSpecification`` object to initialize.
    # :type self: ProjectSpecification
    #]]
    cpp_member(__initialize ProjectSpecification)
    function("${__initialize}" self)

        ProjectSpecification(SET "${self}" name "${CMAKE_PROJECT_NAME}")
        ProjectSpecification(SET "${self}" version "${CMAKE_PROJECT_VERSION}")

        ProjectSpecification(SET "${self}" build_type "${CMAKE_BUILD_TYPE}")

        # Initialize toolchain using CMAKE_TOOLCHAIN_FILE variable
        Toolchain(CTOR my_toolchain "${CMAKE_TOOLCHAIN_FILE}")
        ProjectSpecification(SET "${self}" toolchain "${my_toolchain}")

        # Set the configure_options map to an empty map
        cpp_map(CTOR tmp_configure_options)
        Toolchain(SET "${self}" configure_options "${tmp_configure_options}")

        # Set the compile_options map to an empty map
        cpp_map(CTOR tmp_compile_options)
        Toolchain(SET "${self}" compile_options "${tmp_compile_options}")

    endfunction()

cpp_end_class()
