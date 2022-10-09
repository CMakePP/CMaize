include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/project/project_specification)
include(cmaize/utilities/utilities)

#[[[
# The ``CMaizeProject`` provides a workspace to collect information about a
# project, using that information to build and package the project.
#]]
cpp_class(CMaizeProject)
    
    #[[[
    # :type: desc
    #
    # Name of the project.
    #]]
    cpp_attr(CMaizeProject name)

    #[[[
    # :type: ProjectSpecification
    #
    # Details about the project.
    #]]
    cpp_attr(CMaizeProject specification)

    #[[[
    # :type: list[desc]
    #
    # Languages used in the project.
    #]]
    cpp_attr(CMaizeProject languages)

    #[[[
    # :type: list[PackageManager]
    #
    # Package managers used by the project.
    #]]
    cpp_attr(CMaizeProject package_managers)

    #[[[
    # :type: list[Target]
    #
    # Targets that are a part of the project.
    #]]
    cpp_attr(CMaizeProject targets)

    #[[[
    # Default constructor for ProjectSpecification object with only
    # autopopulated options available.
    #
    # :param self: CMaizeProject object constructed.
    # :type self: CMaizeProject
    # :param name: Name of the project. Must be unique.
    # :type name: desc
    # :returns: ``self`` will be set to the newly constructed
    #           ``ProjectSpecification`` object.
    # :rtype: ProjectSpecification
    #]]
    cpp_constructor(CTOR CMaizeProject desc args)
    macro("${CTOR}" self _ctor_name)

        set(_ctor_lists LANGUAGES)
        cmake_parse_arguments(_ctor "" "" "${_ctor_lists}" ${ARGN})

        CMaizeProject(SET "${self}" name "${_ctor_name}")

        CMaizeProject(SET "${self}" languages "${_ctor_languages}")

        # Create a vanilla CMake project, passing in all potential keyword
        # arguments as well
        project("${_ctor_name}" ${ARGN})
        message("Project created: ${PROJECT_NAME}")

        # Create a project specification that defaults to the values set
        # in the above ``project()`` call
        ProjectSpecification(CTOR proj_spec)
        CMaizeProject(SET "${self}" specification "${proj_spec}")

    endmacro()

    #[[[
    # Set the project version variable and splits the version into 
    # major, minor, patch, and tweak components.
    #
    # :param self: ``CMaizeProject`` object.
    # :type self: CMaizeProject
    # :param project_version: Full project version string.
    # :type project_version: str
    #]]
    cpp_member(set_version CMaizeProject str)
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
    # :param self: ``CMaizeProject`` object to initialize.
    # :type self: CMaizeProject
    #]]
    cpp_member(__initialize CMaizeProject)
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
