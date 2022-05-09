include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/toolchain/toolchain)
include(cmaize/utilities/utilities)

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
    #
    # :var name: Name of project or dependency as a string.
    # :vartype name: str
    #]]
    cpp_attr(ProjectSpecification name)

    #[[[
    # Version of project or dependency as a string.
    #
    # :var version: Version of project or dependency as a string.
    # :vartype version: str
    #]]
    cpp_attr(ProjectSpecification version)

    #[[[
    # First version number component of the ``version`` attribute.
    #
    # :var major_version: First version number component of the ``version``
    #                     attribute.
    # :vartype major_version: str
    #]]
    cpp_attr(ProjectSpecification major_version)

    #[[[
    # Second version number component of the ``version`` attribute.
    #
    # :var minor_version: Second version number component of the ``version``
    #                     attribute.
    # :vartype minor_version: str
    #]]
    cpp_attr(ProjectSpecification minor_version)

    #[[[
    # Third version number component of the ``version`` attribute.
    #
    # :var patch_version: Third version number component of the ``version``
    #                     attribute.
    # :vartype patch_version: str
    #]]
    cpp_attr(ProjectSpecification patch_version)

    #[[[
    # Fourth version number component of the ``version`` attribute.
    #
    # :var tweak_version: Fourth version number component of the ``version``
    #                     attribute.
    # :vartype tweak_version: str
    #]]
    cpp_attr(ProjectSpecification tweak_version)

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
    #
    # :var build_type: Specifies the build type.
    # :vartype build_type: str
    #]]
    cpp_attr(ProjectSpecification build_type)

    #[[[
    # User-specified and autopopulated toolchain file values.
    #
    # :var toolchain: User-specified and autopopulated toolchain file values.
    # :vartype toolchain: ``Toolchain``
    #]]
    cpp_attr(ProjectSpecification toolchain)

    #[[[
    # Project configure options.
    #
    # :var configure_options: Project configure options.
    # :vartype configure_options: ``cpp_map``
    #]]
    cpp_attr(ProjectSpecification configure_options)

    #[[[
    # Project compile options.
    #
    # :var compile_options: Project compile options.
    # :vartype compile_options: ``cpp_map``
    #]]
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
    # Override to ``set_version()`` method to catch when the project version
    # string is blank.
    #]]
    cpp_member(set_version ProjectSpecification)
    function("${set_version}" self)

        ProjectSpecification(SET "${self}" version "")
        ProjectSpecification(SET "${self}" major_version "")
        ProjectSpecification(SET "${self}" minor_version "")
        ProjectSpecification(SET "${self}" patch_version "")
        ProjectSpecification(SET "${self}" tweak_version "")

    endfunction()

    #[[[
    # Set the project version variable and splits the version into 
    # major, minor, patch, and tweak components.
    #
    # :param project_version: Full project version string.
    # :type project_version: str
    #]]
    cpp_member(set_version ProjectSpecification str)
    function("${set_version}" self project_version)

        cmaize_split_version(major minor patch tweak "${project_version}")

        ProjectSpecification(SET "${self}" version "${project_version}")
        ProjectSpecification(SET "${self}" major_version "${major}")
        ProjectSpecification(SET "${self}" minor_version "${minor}")
        ProjectSpecification(SET "${self}" patch_version "${patch}")
        ProjectSpecification(SET "${self}" tweak_version "${tweak}")

    endfunction()

    #[[[
    # Initialize project attributes with default values.
    #
    # :param self: ``ProjectSpecification`` object to initialize.
    # :type self: ProjectSpecification
    #]]
    cpp_member(__initialize ProjectSpecification)
    function("${__initialize}" self)

        # Get the name from the most recent ``project()`` call
        ProjectSpecification(SET "${self}" name "${PROJECT_NAME}")
        
        # Get the version from the most recent ``project()`` call
        ProjectSpecification(set_version "${self}" "${PROJECT_VERSION}")

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
