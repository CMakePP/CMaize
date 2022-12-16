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

        # Initialize map attributes with empty maps
        cpp_map(CTOR _ctor_pm_map)
        CMaizeProject(SET "${self}" package_managers "${_ctor_pm_map}")

        cpp_map(CTOR _ctor_bt_map)
        CMaizeProject(SET "${self}" build_targets "${_ctor_bt_map}")

        cpp_map(CTOR _ctor_it_map)
        CMaizeProject(SET "${self}" installed_targets "${_ctor_it_map}")

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
    # Add a package manager to the project. Duplicate package manager types
    # will not be added.
    #
    # :param self: CMaizeProject object.
    # :type self: CMaizeProject
    # :param _apm_pm: Package manager object to be added.
    # :type _apm_pm: Package manager
    #]]
    cpp_member(add_package_manager CMaizeProject PackageManager)
    function("${add_package_manager}" self _apm_pm)

        # Check if a package manager with the same type exists already
        PackageManager(GET "${_apm_pm}" _apm_pm_type type)
        CMaizeProject(check_package_manager
            "${self}" _apm_found "${_apm_pm_type}"
        )

        # Package manager already exists, exit early
        # TODO: Should we throw an error here, or maybe just overwrite the
        #       existing package manager?
        if(_apm_found)
            cpp_return("")
        endif()

        # Add the package manager collection to add to
        CMaizeProject(GET "${self}" _apm_pm_map package_managers)

        # Add the package manager to the map
        cpp_map(SET "${_apm_pm_map}" "${_apm_pm_type}" "${_apm_pm}")

        # Update the package manager collection attribute
        CMaizeProject(SET "${self}" package_managers "${_apm_pm_map}")

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
        set(_at_options NAME)
        cmake_parse_arguments(_at "${_at_flags}" "${_at_options}" "" ${ARGN})

        # Default to the build target list
        set(_at_tgt_attr "build_targets")
        if(_at_INSTALLED)
            set(_at_tgt_attr "installed_targets")
        endif()

        # If a name was not given, default to the 
        if("${_at_NAME}" STREQUAL "")
            Target(target "${_at_target}" _at_NAME)
        endif()

        # Check if a Target with the same name exists already
        CMaizeProject(check_target
            "${self}"
            _at_found
            NAME "${_at_NAME}"
            ${_at_UNPARSED_ARGUMENTS}
        )

        # Exit early if a target with the same name already exists
        # TODO: Should we throw an error here, or maybe just overwrite the
        #       existing target?
        if(_at_found)
            cpp_return("")
        endif()

        # Add the target to the list if it doesn't already exist
        CMaizeProject(GET "${self}" _at_tgt_map "${_at_tgt_attr}")

        cpp_map(SET "${_at_tgt_map}" "${_at_NAME}" "${_at_target}")
        
        CMaizeProject(SET "${self}" "${_at_tgt_attr}" "${_at_tgt_map}")

    endfunction()

    #[[[
    # Checks if a package manager with the same type is already added to
    # this project.
    #
    # :param self: CMaizeProject object.
    # :type self: CMaizeProject
    # :param cpm_found: Return variable for if the package manager was found.
    # :type cpm_found: bool*
    # :param cpm_tgt: Package manager to search for.
    # :type cpm_tgt: Package manager
    #
    # :returns: Package manager found (TRUE) or not (FALSE).
    # :rtype: bool
    #]]
    cpp_member(check_package_manager CMaizeProject desc desc)
    function("${check_package_manager}" self  _cpm_found _cpm_pm_type)

        # Get the collection of package managers
        CMaizeProject(GET "${self}" _cpm_pm_map package_managers)

        # Check if a package manager of that type already exists
        cpp_map(HAS_KEY "${_cpm_pm_map}" "${_cpm_found}" "${_cpm_pm_type}")
        cpp_return("${_cpm_found}")

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
    cpp_member(check_target CMaizeProject desc args)
    function("${check_target}" self  _ct_found)

        set(_ct_flags INSTALLED)
        set(_ct_options NAME)
        cmake_parse_arguments(_ct "${_ct_flags}" "${_ct_options}" "" ${ARGN})

        # Default to the build target list
        set(_ct_tgt_attr "build_targets")
        if(_ct_INSTALLED)
            set(_ct_tgt_attr "installed_targets")
        endif()

        list(FIND _ct_KEYWORDS_MISSING_VALUES "NAME" _ct_name_found)
        if(NOT _ct_name_found)
            cpp_raise(MissingArgument "Keyword argument NAME must be provided.")
            cpp_return("")
        endif()

        # Get the collection of targets
        CMaizeProject(GET "${self}" _ct_tgt_map "${_ct_tgt_attr}")

        # Check if a target with the same name already exists
        cpp_map(HAS_KEY "${_ct_tgt_map}" "${_ct_found}" "${_ct_NAME}")
        cpp_return("${_ct_found}")

    endfunction()

    cpp_member(get_package_manager CMaizeProject desc desc)
    function("${get_package_manager}" self  _gpm_result _gpm_pm_type)

        CMaizeProject(GET "${self}" _gpm_pm_map package_managers)

        CMaizeProject(check_package_manager
            "${self}" _gpm_found "${_gpm_pm_type}"
        )
        if(NOT _gpm_found)
            # Package manager was not found
            set("${_gpm_result}" "")
            cpp_return("${_gpm_result}")
        endif()

        # Package manager was found, return it
        cpp_map(GET "${_gpm_pm_map}" _gpm_pm "${_gpm_pm_type}")

        set("${_gpm_result}" "${_gpm_pm}")
        cpp_return("${_gpm_result}")

    endfunction()

    cpp_member(get_target CMaizeProject desc args)
    function("${get_target}" self  _gt_result)

        set(_gt_flags INSTALLED)
        set(_gt_options NAME)
        cmake_parse_arguments(_gt "${_gt_flags}" "${_gt_options}" "" ${ARGN})

        # Default to the build target list
        set(_gt_tgt_attr "build_targets")
        if(_gt_INSTALLED)
            set(_gt_tgt_attr "installed_targets")
        endif()

        list(FIND _gt_KEYWORDS_MISSING_VALUES "NAME" _gt_name_found)
        if(NOT _gt_name_found)
            cpp_raise(MissingArgument "Keyword argument NAME must be provided.")
            cpp_return("")
        endif()

        # Get the collection of targets
        CMaizeProject(GET "${self}" _gt_tgt_map "${_gt_tgt_attr}")

        # Find the specified target
        cpp_map(GET "${_gt_tgt_map}" "${_gt_NAME}" "${_gt_result}")

        cpp_return("${_gt_result}")

    endfunction()

cpp_end_class()
