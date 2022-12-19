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

    endfunction()

    #[[[
    # Add a target to the project. Duplicate objects will be removed.
    #
    # :param _at_target_name: Identifying name for the target. This can match
    #                         name of either the CMake target or CMaize Target
    #                         object, but is required to do match them.
    # :type _at_target_name: desc or target
    # :param _at_target: Target object to be added.
    # :type _at_target: Target
    #
    # :Keyword Arguments:
    #    * **INSTALLED** (*bool*) --
    #      Flag to indicate that the target being added is already installed
    #      on the system.
    #]]
    cpp_member(add_target CMaizeProject str Target args)
    function("${add_target}" self _at_target_name _at_target)

        CMaizeProject(_add_target
            "${self}" "${_at_target}" NAME "${_at_target_name}" ${ARGN}
        )

    endfunction()

    #[[[
    # Add a target to the project. Duplicate objects will be removed.
    #
    # Overload for ``add_target()`` to handle target names of the ``target``
    # type. See the main ``add_target()`` definition for full description.
    #]]
    cpp_member(add_target CMaizeProject target Target args)
    function("${add_target}" self _at_target_name _at_target)

        CMaizeProject(_add_target
            "${self}" "${_at_target}" NAME "${_at_target_name}" ${ARGN}
        )

    endfunction()

    #[[[
    # Add a target to the project. Duplicate objects will not be added.
    #
    # This internal implementation exists so a required keyword argument is
    # not part of the public interface, as well as to handle both ``desc`` and
    # ``target`` types. Both types are effectively strings representing target
    # names in this algorithm and can be treated equivalently, but cannot be
    # typecast to each other by CMakePPLang. The CMakePPLang type checking
    # is bypassed through the aforementioned required keyword argument for
    # the target name, essentially combining the two types.
    #
    # :param _at_target: Target object to be added.
    # :type _at_target: Target
    # :param NAME: Required keyword argument. See description below.
    # :type NAME: desc or target
    #
    # :Keyword Arguments:
    #    * **INSTALLED** (*bool*) --
    #      Flag to indicate that the target being added is already installed
    #      on the system.
    #    * **NAME** (*desc* or *target*) -- 
    #      Identifying name for the target. This can match name of either the
    #      CMake target or CMaize Target object, but is required to do match
    #      them. This keyword argument is **required**.
    #]]
    cpp_member(_add_target CMaizeProject Target args)
    function("${_add_target}" self __at_target)

        set(__at_flags INSTALLED)
        set(__at_one_value_args NAME)
        cmake_parse_arguments(__at "${__at_flags}" "${__at_one_value_args}" "" ${ARGN})

        # Ensure that NAME was provided
        cpp_contains(__at_name_exists __at_NAME "${__at_KEYWORDS_MISSING_VALUES}")
        if(__at_name_exists)
            cpp_raise(KeywordMissing "Missing required keyword argument: NAME")
        endif()

        # Default to the build target list
        set(__at_tgt_attr "build_targets")
        if(__at_INSTALLED)
            set(__at_tgt_attr "installed_targets")
        endif()

        # Check if a Target with the same name exists already as either
        # a build or installed target
        CMaizeProject(check_target
            "${self}"
            __at_found
            "${__at_NAME}"
            ALL
        )

        # Exit early if a target with the same name already exists
        # TODO: Should we throw an error here, or maybe just overwrite the
        #       existing target?
        if(__at_found)
            cpp_return("")
        endif()

        # Add the target to the list if it doesn't already exist
        CMaizeProject(GET "${self}" __at_tgt_map "${__at_tgt_attr}")

        cpp_map(SET "${__at_tgt_map}" "${__at_NAME}" "${__at_target}")

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
    # :param _ct_found: Return variable for if the target was found.
    # :type _ct_found: bool*
    # :param _ct_target_name: Identifying name for the target. This can match
    #                         name of either the CMake target or CMaize Target
    #                         object, but is required to do match them.
    # :type _ct_target_name: desc or target
    #
    # :returns: Target found (TRUE) or not (FALSE).
    # :rtype: bool
    #]]
    cpp_member(check_target CMaizeProject desc desc args)
    function("${check_target}" self  _ct_found _ct_target_name)

        CMaizeProject(_check_target
            "${self}" "${_ct_found}" NAME "${_ct_target_name}" ${ARGN}
        )
        cpp_return("${_ct_found}")

    endfunction()

    cpp_member(check_target CMaizeProject desc target args)
    function("${check_target}" self  _ct_found _ct_target_name)

        CMaizeProject(_check_target
            "${self}" "${_ct_found}" NAME "${_ct_target_name}" ${ARGN}
        )
        cpp_return("${_ct_found}")

    endfunction()

    cpp_member(_check_target CMaizeProject desc args)
    function("${_check_target}" self  __ct_found)

        set(__ct_flags INSTALLED ALL)
        set(__ct_one_value_args NAME)
        cmake_parse_arguments(__ct "${__ct_flags}" "${__ct_one_value_args}" "" ${ARGN})

        # Ensure that NAME was provided
        cpp_contains(__ct_name_exists __ct_NAME "${__ct_KEYWORDS_MISSING_VALUES}")
        if(__ct_name_exists)
            cpp_raise(KeywordMissing "Missing required keyword argument: NAME")
        endif()

        # Default to the build target list
        set(__ct_tgt_attr "build_targets")
        if(__ct_ALL)
            # Search both lists
            list(APPEND __ct_tgt_attr "installed_targets")
        elseif(__ct_INSTALLED)
            set(__ct_tgt_attr "installed_targets")
        endif()

        foreach(__ct_tgt_attr_i ${__ct_tgt_attr})
            # Get the collection of targets
            CMaizeProject(GET "${self}" __ct_tgt_map "${__ct_tgt_attr_i}")

            # Check if a target with the same name already exists
            cpp_map(HAS_KEY "${__ct_tgt_map}" __ct_found_i "${__ct_NAME}")

            # Return early if target is found
            if(__ct_found_i)
                set("${__ct_found}" "${__ct_found_i}")
                cpp_return("${__ct_found}")
            endif()
        endforeach()

        set("${__ct_found}" FALSE)
        cpp_return("${__ct_found}")

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

    cpp_member(get_target CMaizeProject desc desc args)
    function("${get_target}" self  _gt_result _gt_target_name)

        CMaizeProject(_get_target
            "${self}" "${_gt_result}" NAME "${_gt_target_name}" ${ARGN}
        )
        cpp_return("${_gt_result}")

    endfunction()

    cpp_member(get_target CMaizeProject desc target args)
    function("${get_target}" self  _gt_result _gt_target_name)

        CMaizeProject(_get_target
            "${self}" "${_gt_result}" NAME "${_gt_target_name}" ${ARGN}
        )
        message("-- DEBUG: _gt_result: ${_gt_result}: ${${_gt_result}}")
        cpp_return("${_gt_result}")

    endfunction()

    cpp_member(_get_target CMaizeProject desc args)
    function("${_get_target}" self  __gt_result)

        set(__gt_flags INSTALLED)
        set(__gt_one_value_args NAME)
        cmake_parse_arguments(
            __gt "${__gt_flags}" "${__gt_one_value_args}" "" ${ARGN}
        )

        # Ensure that NAME was provided
        cpp_contains(
            __gt_name_exists __gt_NAME "${__gt_KEYWORDS_MISSING_VALUES}"
        )
        if(__gt_name_exists)
            cpp_raise(KeywordMissing "Missing required keyword argument: NAME")
        endif()

        # Default to the build target list
        set(__gt_tgt_attr "build_targets")
        if(__gt_INSTALLED)
            set(__gt_tgt_attr "installed_targets")
        endif()

        # Get the collection of targets
        CMaizeProject(GET "${self}" __gt_tgt_map "${__gt_tgt_attr}")

        # Find the specified target
        cpp_map(GET "${__gt_tgt_map}" "${__gt_result}" "${__gt_NAME}")

        cpp_return("${__gt_result}")

    endfunction()

cpp_end_class()
