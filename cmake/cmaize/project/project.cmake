include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/target)
include(cmaize/project/project_specification)
include(cmaize/utilities/utilities)

#[[[
# The ``CMaizeProject`` provides a workspace to collect information about a
# project, using that information to build and package the project.
#
# This object will **not** create a CMake project if one does not already
# exist.
#
# **Usage:**
# 
# A ``CMaizeProject`` object will be automatically created for the current
# when CMaize is included in a ``CMakeLists.txt`` file if a ``project()``
# call has already been made. This project should not be created manually
# in most cases.
#
# To retrieve an existing project object, call:
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
    # :type: list[BuildTarget]
    #
    # Targets that will be built as part of the project.
    #]]
    cpp_attr(CMaizeProject build_targets)

    #[[[
    # :type: list[InstalledTarget]
    #
    # Targets the project uses that are already installed on the system.
    #]]
    cpp_attr(CMaizeProject installed_targets)

    #[[[
    # Creates a ``CMaizeProject`` object. A CMake project of the same name
    # must already be created through a ``project()`` call and must be
    # the active project.
    #
    # :param self: The constructed object.
    # :type self: CMaizeProject
    # :param _ctor_name: Name of the project. Must match the active project
    #                    named in ``PROJECT_NAME``.
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
    # :raises ProjectNotFound: The active CMake project does not match the
    #                          given project name.
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
            set(_ctor_msg 
                "The given project name does not match the current CMake"
                "project. Make sure that `project()` was called before"
                "creating a CMaize project."
                "\nProject given: ${_ctor_name}"
                "\nCurrent project: ${PROJECT_NAME}"
            )
            string(JOIN " " _ctor_msg ${_ctor_msg})
            cpp_raise(
                ProjectNotFound
                "${_ctor_msg}"
            )
        endif()

        # Create a project specification that defaults to the values set
        # in the above ``project()`` call
        ProjectSpecification(CTOR proj_spec)
        CMaizeProject(SET "${self}" specification "${proj_spec}")

    endfunction()

    #[[[
    # Add a language to the project. Duplicate languages will be removed.
    #
    # :param self: CMaizeProject object.
    # :type self: CMaizeProject
    # :param _al_language: Language to be added.
    # :type _al_language: desc
    #]]
    cpp_member(add_language CMaizeProject desc)
    function("${add_language}" self _al_language)

        CMaizeProject(GET "${self}" _al_language_list languages)

        list(FIND _al_language_list "${_al_language}" _al_found)

        # Add the language to the list if it doesn't exist
        if("${_al_found}" STREQUAL "-1")
            list(APPEND _al_language_list "${_al_language}")
            CMaizeProject(SET "${self}" languages "${_al_language_list}")
        endif()

    endfunction()

    #[[[
    # Add a target to the project. Duplicate objects will be removed.
    #
    # :param self: CMaizeProject object.
    # :type self: CMaizeProject
    # :param _at_target: Target object to be added.
    # :type _at_target: Target
    #
    # :Keyword Arguments:
    #    * **INSTALLED** (*bool*) --
    #      Flag to indicate that the target being added is already installed
    #      on the system.
    #]]
    cpp_member(add_target CMaizeProject Target args)
    function("${add_target}" self _at_target)

        set(_at_flags INSTALLED)
        cmake_parse_arguments(_at "${_at_flags}" "" "" ${ARGN})

        # Default to CMake package manager if none were given
        set(_at_tgt_attr "build_targets")
        if(_at_INSTALLED)
            set(_at_tgt_attr "installed_targets")
        endif()

        # Check if a Target with the same name exists already
        CMaizeProject(_check_target "${self}" _at_found "${_at_target}")

        # Add the target to the list if it doesn't already exist
        if(NOT _at_found)
            CMaizeProject(GET "${self}" _at_tgt_list ${_at_tgt_attr})
            list(APPEND _at_tgt_list "${_at_target}")        
            CMaizeProject(SET "${self}" ${_at_tgt_attr} "${_at_tgt_list}")
        endif()

    endfunction()

    #[[[
    # Checks if a target with the same name is already added to this project.
    #
    # This checks both the build and installed target lists.
    #
    # :param self: CMaizeProject object.
    # :type self: CMaizeProject
    # :param _ct_found: Return variable for if the target was found.
    # :type _ct_found: bool*
    # :param _ct_tgt: Target to search for.
    # :type _ct_tgt: Target
    #
    # :returns: Target found (TRUE) or not (FALSE).
    # :rtype: bool
    #]]
    cpp_member(_check_target CMaizeProject desc Target)
    function("${_check_target}" self  _ct_found _ct_tgt)

        Target(target "${_ct_tgt}" _ct_tgt_name)

        # Search each list of targets in the project
        foreach(_ct_tgt_list_i "build_targets" "installed_targets")
            CMaizeProject(GET "${self}" _ct_tgt_list ${_ct_tgt_list_i})

            # Search the list for a target with a matching name
            foreach(_ct_tgt_i ${_ct_tgt_list})
                Target(target "${_ct_tgt_i}" _ct_tgt_i_name)
                
                # Exit early if a target with the same name is found
                if("${_ct_tgt_name}" STREQUAL "${_ct_tgt_i_name}")
                    set("${_ct_found}" TRUE)
                    cpp_return("${_ct_found}")
                endif()
            endforeach()
        endforeach()

        # Target was not found
        set("${_ct_found}" FALSE)
        cpp_return("${_ct_found}")

    endfunction()

cpp_end_class()
