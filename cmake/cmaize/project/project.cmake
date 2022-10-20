include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/project/project_specification)
include(cmaize/utilities/utilities)

#[[[
# The ``CMaizeProject`` provides a workspace to collect information about a
# project, using that information to build and package the project.
#
# **Usage:**
# 
# A ``CMaizeProject`` object will be automatically created for the current
# when CMaize is included in a ``CMakeLists.txt`` file if a ``project()``
# call has already been made. Otherwise, the ``cmaize_project()`` user
# function will create one and store it in the global
# ``CMAIZE_PROJECT_<project_name>`` variable.
#
# To retrieve an existing project object created in these ways, call:
# 
# .. code-block:: cmake
#
#    cpp_get_global(result_object CMAIZE_PROJECT_<project_name>)
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
    # Languages used in the project. Defaults to an empty list.
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
    # Creates a ``CMaizeProject`` object and underlying CMake project, if
    # necessary.
    #
    # The underlying CMake project is only created if the given project name
    # does not match the CMake project name in ``PROJECT_NAME``.
    #
    # :param self: The constructed object.
    # :type self: CMaizeProject
    # :param _ctor_name: Name of the project.
    # :type _ctor_name: desc
    #
    # :Keyword Arguments:
    #    * **VERSION** (*desc*) --
    #      Version string of non-negative integers of the form
    #      ``<major>[.<minor>[.<patch>[.<tweak>] ] ]``. Populates the
    #      version attributes of the ``ProjectSpecification``. Parallels
    #      the ``VERSION <version>`` keyword for CMake ``project()``
    #      (`link <cmake_project_>`__), and the value is passed to
    #      a CMake ``project()`` call if the project does not exist yet.
    #    * **DESCRIPTION** (*desc*) --
    #      Description of the project. Parallels the 
    #      ``DESCRIPTION <project-description-string>`` keyword for 
    #      CMake ``project()`` (`link <cmake_project_>`__), and the value
    #      is passed to a CMake ``project()`` call if the project does not
    #      exist yet.
    #    * **HOMEPAGE_URL** (*desc*) --
    #      Homepage URL for the project. Parallels the
    #      ``HOMEPAGE_URL <url-string>`` keyword for CMake ``project()``
    #      (`link <cmake_project_>`__), and the value is passed to
    #      a CMake ``project()`` call if the project does not exist yet.
    #    * **LANGUAGES** (*list[desc]*) --
    #      Languages supported by the project. These languages are passed to
    #      the LANGUAGES keyword of the CMake ``project()`` call if the project
    #      does not exist yet.
    #
    # :returns: ``self`` will be set to the newly constructed
    #           ``CMaizeProject`` object.
    # :rtype: CMaizeProject
    # 
    # .. Reference definitions
    # .. _cmake_project: https://cmake.org/cmake/help/latest/command/project.html
    #]]
    cpp_constructor(CTOR CMaizeProject str args)
    function("${CTOR}" self _ctor_name)

        set(_ctor_lists LANGUAGES)
        cmake_parse_arguments(_ctor "" "" "${_ctor_lists}" ${ARGN})

        CMaizeProject(SET "${self}" name "${_ctor_name}")

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

    #[[[
    # Add a target to the project. Duplicate objects will be removed.
    #
    # :param self: CMaizeProject object.
    # :type self: CMaizeProject
    # :param _at_target: Target object to be added.
    # :type _at_target: BuildTarget
    #]]
    cpp_member(add_target CMaizeProject BuildTarget)
    function("${add_target}" self _at_target)

        CMaizeProject(GET "${self}" _at_target_list targets)
        list(APPEND _at_target_list "${_at_target}")
        list(REMOVE_DUPLICATES _at_target_list)
        CMaizeProject(SET "${self}" targets "${_at_target_list}")

    endfunction()

cpp_end_class()
