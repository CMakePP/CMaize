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
    cpp_constructor(CTOR CMaizeProject str args)
    function("${CTOR}" self _ctor_name)

        set(_ctor_flags EXISTS)
        set(_ctor_lists LANGUAGES)
        cmake_parse_arguments(_ctor "${_ctor_flags}" "" "${_ctor_lists}" ${ARGN})

        CMaizeProject(SET "${self}" name "${_ctor_name}")

        CMaizeProject(SET "${self}" languages "${_ctor_languages}")

        # Create a vanilla CMake project, passing in all potential keyword
        # arguments as well
        if(NOT "${_ctor_EXISTS}")
            project("${_ctor_name}" ${ARGN})
        endif()

        # Create a project specification that defaults to the values set
        # in the above ``project()`` call
        # CMaizeProject(_create_spec "${self}" spec ${ARGN})
        ProjectSpecification(CTOR proj_spec)
        CMaizeProject(SET "${self}" specification "${proj_spec}")

        # CMaizeProject(_take_over "${self}")

    endfunction()

    cpp_member(add_target CMaizeProject BuildTarget)
    function("${add_target}" self target)

        CMaizeProject(GET "${self}" _at_targets targets)
        list(APPEND _at_targets "${target}")
        list(REMOVE_DUPLICATES _at_targets)
        CMaizeProject(SET "${self}" targets "${_at_targets}")

    endfunction()

    cpp_member(_create_spec CMaizeProject ProjectSpecification args)
    function("${_create_spec}" self return_value)

        # Parse project keyword arguments
        set(_ctor_lists LANGUAGES)
        cmake_parse_arguments(_ctor "" "" "${_ctor_lists}" ${ARGN})

        ProjectSpecification(CTOR _cs_spec)

        ProjectSpecification()

    endfunction()

    #[[[
    # Since the creation of a project through CMaizeProject instantiation
    # can never be a literal, direct call in the top-level CMakeLists.txt
    # file, the created project needs to be manually set to the top-level
    # project.
    #
    # :param self: ``CMaizeProject`` object.
    # :type self: CMaizeProject
    #]]
    cpp_member(_take_over CMaizeProject)
    function("${_take_over}" self)

        CMaizeProject(GET "${self}" specs specification)
        ProjectSpecification(GET "${specs}" _to_name name)
        ProjectSpecification(GET "${specs}" _to_version version)

        # Make note of the current top-level project name
        set(tmp_top_proj "${CMAKE_PROJECT_NAME}")

        set(CMAKE_PROJECT_NAME "${_ctor_name}")
        set(CMAKE_PROJECT_VERSION "${${_ctor_name}_VERSION}")
        set(CMAKE_PROJECT_DESCRIPTION "${${_ctor_name}_DESCRIPTION}")
        set(CMAKE_PROJECT_HOMEPAGE_URL "${${_ctor_name}_HOMEPAGE_URL}")
        set(PROJECT_SOURCE_DIR "${${tmp_top_proj}_SOURCE_DIR}")
        set(${_ctor_name}_SOURCE_DIR "${${tmp_top_proj}_SOURCE_DIR}")
        set(PROJECT_BINARY_DIR "${${tmp_top_proj}_BINARY_DIR}")
        set(${_ctor_name}_BINARY_DIR "${${tmp_top_proj}_BINARY_DIR}")
        set(PROJECT_IS_TOP_LEVEL "${${tmp_top_proj}_IS_TOP_LEVEL}")
        set(${_ctor_name}_IS_TOP_LEVEL "${${tmp_top_proj}_IS_TOP_LEVEL}")

    endfunction()

cpp_end_class()
