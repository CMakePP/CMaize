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

include(cmaize/targets/cmaize_target)
include(cmaize/project/package_specification)
include(cmaize/project/impl_/impl_)
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
    # :type: PackageSpecification
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
    # :type self: CMaizeProject*
    # :param _ctor_name: Name of the project. Must match the active project
    #                    named in ``PROJECT_NAME``.
    # :type _ctor_name: desc
    #
    # :Keyword Arguments:
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

        set(_ctor_multi_value_args LANGUAGES)
        cmake_parse_arguments(_ctor "" "" "${_ctor_multi_value_args}" ${ARGN})

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

        # Create a package specification that defaults to the values set
        # in the above ``project()`` call
        PackageSpecification(CTOR proj_spec)
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
    # Sets the value of the specified configuration option
    #
    # This method is a convience function for retrieving the
    # PackageSpecification associated with self and then setting the value of
    # the specified configuration option.
    #
    # :param self: The current ``CMaizeProject`` object.
    # :type self: CMaizeProject
    # :param name: The key for the configuration option.
    # :type name: desc
    # :param value: The value to set the configuration option to.
    # :type value: str
    #
    #]]
    cpp_member(set_config_option CMaizeProject desc str)
    function("${set_config_option}" self _sco_name _sco_value)

        CMaizeProject(GET "${self}" _sco_specs specification)
        PackageSpecification(
            set_config_option "${_sco_specs}" "${_sco_name}" "${_sco_value}"
        )
    endfunction()

    #[[[
    # Gets the value of a configuration option.
    #
    # This method is a convenience function for retrieving the
    # PackageSpecification associated with self and then getting the value of
    # the specificed configuration option.
    #
    # :param self: The current ``CMaizeProject`` object.
    # :type self: CMaizeProject
    # :param value: The variable which will hold the option's value
    # :type value: str
    # :param name: The configuration option whose value has been requested.
    # :type name: desc
    #
    # :raises KeyError: If ``name`` is not a configuration option which has been
    #                   added via ``set_config_option``. Strong throw guarantee.
    #]]
    cpp_member(get_config_option CMaizeProject str desc)
    function("${get_config_option}" self _gco_value _gco_name)

        CMaizeProject(GET "${self}" _gco_specs specification)
        PackageSpecification(
            get_config_option "${_gco_specs}" "${_gco_value}" "${_gco_name}"
        )
        cpp_return("${_gco_value}")
    endfunction()

    #[[[
    # Determines if a configuration option was added to self.
    #
    # This method is a convenience function for getting the internal
    # PackageSpecification and seeinf if the user set a specified key. If the
    # user set ``name``, ``result`` will be set to true; otherwise, ``result``
    # will be false.
    #
    # :param self: ``CMaizeProject`` object.
    # :type self: CMaizeProject
    # :param result: The identifier to assign the result to.
    # :type result: bool*
    # :param name: The name of the configuration option
    # :type name: desc
    #]]
    cpp_member(has_config_option CMaizeProject bool* desc)
    function("${has_config_option}" self _hco_result _hco_name)

        CMaizeProject(GET "${self}" _hco_specs specification)
        PackageSpecification(
            has_config_option "${_hco_specs}" "${_hco_result}" "${_hco_name}"
        )
        cpp_return("${_hco_result}")

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
    #                         name of either the CMake target or CMaizeTarget
    #                         object, but is required to do match them.
    # :type _at_target_name: desc
    # :param _at_target: CMaizeTarget object to be added.
    # :type _at_target: CMaizeTarget
    # :param **kwargs: Additional keyword arguments may be necessary.
    #
    # :Keyword Arguments:
    #    * **INSTALLED** (*bool*) --
    #      Flag to indicate that the target being added is already installed
    #      on the system.
    #    * **NAME** (*desc* or *target*) --
    #      Identifying name for the target. This can match name of either the
    #      CMake target or CMaizeTarget object, but is required to do match
    #      them. This keyword argument is **required**.
    #]]
    cpp_member(add_target CMaizeProject str CMaizeTarget args)
    function("${add_target}" self _at_target_name _at_target)

        _add_target(
            "${self}" "${_at_target}" NAME "${_at_target_name}" ${ARGN}
        )

    endfunction()

    #[[[
    # Checks if a package manager with the same type is already added to
    # this project.
    #
    # :param self: CMaizeProject object.
    # :type self: CMaizeProject
    # :param _cpm_found: Return variable for if the package manager was found.
    # :type _cpm_found: bool*
    # :param _cpm_tgt: Package manager to search for.
    # :type _cpm_tgt: Package manager
    #
    # :returns: Package manager found (TRUE) or not (FALSE).
    # :rtype: bool
    #]]
    cpp_member(check_package_manager CMaizeProject desc str)
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
    # :param _ct_found: Return variable for if the target was found.
    # :type _ct_found: bool*
    # :param _ct_target_name: Identifying name for the target. This can match
    #                         name of either the CMake target or CMaizeTarget
    #                         object, but is required to do match them.
    # :type _ct_target_name: desc
    # :param **kwargs: Additional keyword arguments may be necessary.
    #
    # :Keyword Arguments:
    #    * **INSTALLED** (*bool*) --
    #      Flag to indicate that the installed targets should be checked.
    #    * **ALL** (*bool*) --
    #      Flag to indicate that both the build and installed targets should
    #      be checked.
    #    * **NAME** (*desc* or *target*) --
    #      Identifying name for a target contained in the current Cmaize
    #      project. This keyword argument is **required**.
    #
    # :returns: CMaizeTarget found (TRUE) or not (FALSE).
    # :rtype: bool
    #]]
    cpp_member(check_target CMaizeProject desc str args)
    function("${check_target}" self  _ct_found _ct_target_name)

        _check_target(
            "${self}" "${_ct_found}" NAME "${_ct_target_name}" ${ARGN}
        )
        cpp_return("${_ct_found}")

    endfunction()

    #[[[
    # Get a package manager of the requested type stored in the project.
    #
    # :param _gpm_result: Return variable for the package manager object.
    # :type _gpm_result: PackageManager*
    # :param _gpm_pm_type: Type of package manager to retrieve. See
    #                      ``CMAIZE_SUPPORTED_PACKAGE_MANAGERS`` for the list
    #                      of supported package manager types.
    # :type _gpm_pm_type: desc
    #
    # :returns: Requested package manager object, or an empty string ("") if
    #           no package manager with the matching type was found.
    # :rtype: PackageManager
    #]]
    cpp_member(get_package_manager CMaizeProject desc str)
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

    #[[[
    # Get a CMaizeTarget with the requested identifying name stored in the project.
    #
    # :param _gt_result: Return variable for the CMaizeTarget object.
    # :type _gt_result: CMaizeTarget*
    # :param _gt_target_name: Identifying name of the target to retrieve. This
    #                         should match the name provided during the
    #                         ``CMaizeProject(add_target`` call.
    # :type _gt_target_name: desc
    # :param **kwargs: Additional keyword arguments may be necessary.
    #
    # :Keyword Arguments:
    #    * **INSTALLED** (*bool*) --
    #      Flag to indicate that the installed targets should be searched.
    #    * **NAME** (*desc* or *target*) --
    #      Identifying name for a target contained in the current Cmaize
    #      project. This keyword argument is **required**.
    #
    # :returns: Requested target object, or an empty string ("") if
    #           no target with the matching type was found.
    # :rtype: CMaizeTarget
    #]]
    cpp_member(get_target CMaizeProject desc str args)
    function("${get_target}" self  _gt_result _gt_target_name)

        CMaizeProject(_get_target
            "${self}" "${_gt_result}" NAME "${_gt_target_name}" ${ARGN}
        )
        cpp_return("${_gt_result}")

    endfunction()

    #[[[
    # Get a CMaizeTarget with the requested identifying name stored in the project.
    #
    # This internal implementation exists so a required keyword argument is
    # not part of the public interface, as well as to handle both ``desc`` and
    # ``target`` types. Both types are effectively strings representing target
    # names in this algorithm and can be treated equivalently, but cannot be
    # typecast to each other by CMakePPLang. The CMakePPLang type checking
    # is bypassed through the aforementioned required keyword argument for
    # the target name, essentially combining the two types.
    #
    # :param __gt_result: Return variable for the resulting target.
    # :type __gt_result: CMaizeTarget*
    # :param NAME: Required keyword argument. See description below.
    # :type NAME: desc or target
    # :param **kwargs: Additional keyword arguments may be necessary.
    #
    # :Keyword Arguments:
    #    * **INSTALLED** (*bool*) --
    #      Flag to indicate that the installed targets should be searched.
    #    * **NAME** (*desc* or *target*) --
    #      Identifying name for a target contained in the current Cmaize
    #      project. This keyword argument is **required**.
    #
    # :returns: Requested target object, or an empty string ("") if
    #           no target with the matching type was found.
    # :rtype: CMaizeTarget
    #]]
    cpp_member(_get_target CMaizeProject desc args)
    function("${_get_target}" self  __gt_result)

        set(__gt_options INSTALLED ALL)
        set(__gt_one_value_args NAME)
        cmake_parse_arguments(
            __gt "${__gt_options}" "${__gt_one_value_args}" "" ${ARGN}
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
        if(__gt_ALL)
            # Search both lists
            list(APPEND __gt_tgt_attr "installed_targets")
        elseif(__gt_INSTALLED)
            set(__gt_tgt_attr "installed_targets")
        endif()

        set("${__gt_result}" "")
        foreach(__gt_tgt_attr_i ${__gt_tgt_attr})
            # Get the collection of targets
            CMaizeProject(GET "${self}" __gt_tgt_map "${__gt_tgt_attr_i}")

            # Find the specified target
            cpp_map(GET "${__gt_tgt_map}" __gt_tgt_obj "${__gt_NAME}")

            if(NOT "${__gt_tgt_obj}" STREQUAL "")
                set("${__gt_result}" "${__gt_tgt_obj}")

                cpp_return("${__gt_result}")
            endif()
        endforeach()

        cpp_return("${__gt_result}")

    endfunction()

cpp_end_class()
