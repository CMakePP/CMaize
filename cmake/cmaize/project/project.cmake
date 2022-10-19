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

        set(_ctor_lists LANGUAGES)
        cmake_parse_arguments(_ctor "" "" "${_ctor_lists}" ${ARGN})

        CMaizeProject(SET "${self}" name "${_ctor_name}")

        if("${_ctor_LANGUAGES}" STREQUAL "")
            get_property(_ctor_LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)
        endif()
        CMaizeProject(SET "${self}" languages "${_ctor_LANGUAGES}")

        # If the project name is different than the current project, assume
        # a new CMake project needs to be created
        if(NOT "${_ctor_name}" STREQUAL "${PROJECT_NAME}")
            project("${_ctor_name}" ${ARGN})
        endif()

        # Create a project specification that defaults to the values set
        # in the above ``project()`` call
        ProjectSpecification(CTOR proj_spec)
        CMaizeProject(SET "${self}" specification "${proj_spec}")

    endfunction()

    cpp_member(add_target CMaizeProject BuildTarget)
    function("${add_target}" self target)

        CMaizeProject(GET "${self}" _at_targets targets)
        list(APPEND _at_targets "${target}")
        list(REMOVE_DUPLICATES _at_targets)
        CMaizeProject(SET "${self}" targets "${_at_targets}")

    endfunction()

cpp_end_class()
