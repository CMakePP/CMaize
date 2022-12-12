include_guard()
include(cmakepp_lang/cmakepp_lang)

include(cmaize/package_managers/cmake/dependency/detail_/check_target)
include(cmaize/utilities/fetch_and_available)

#[[[ Models a dependency of the main CMake Project.
#
# The base class is for dependencies which behave close to ideal (from the
# standpoint of CMake). In particular we assume the dependency:
#
# - can be found by calling ``find_package`` in ``CONFIG`` mode
# - added to the main project's build step via CMake's fetch command
# - exports a CMake target
#
#]]
cpp_class(Dependency)
    ###########################################################################
    #[[ ---------------------------- Attributes ---------------------------- ]]
    ###########################################################################

    ## If we are building the dependency this will be the name of the target
    cpp_attr(Dependency build_target)

    ## CMake variables that need to be set before building the dependency
    cpp_attr(Dependency cmake_args)

    ## If we find the dependency this will be the name of the target
    cpp_attr(Dependency find_target)

    ## Did we find this dependency yet?
    cpp_attr(Dependency found FALSE)

    ## Name of the dependency
    cpp_attr(Dependency name)

    ## This is the target (accounting for build vs. find) to link against
    cpp_attr(Dependency target)

    ## What version of the dependency do we want?
    cpp_attr(Dependency version)

    ##########################################################################
    #[[ ---------------------------- Functions ---------------------------- ]]
    ##########################################################################

    #[[[ Computes a list of path prefixes which should be used when searching.
    #
    # This function encapsulates assembling a list of all the prefixes which
    # should be considered when looking for this dependency.
    #
    # :param _sp_this: The Dependency instance being used to assemble the paths.
    # :type _sp_this: Dependency
    # :param _sp_result: Name for variable which will hold the result.
    # :type _sp_result: desc
    #]]
    cpp_member(_search_paths Dependency desc)
    function("${_search_paths}" _sp_this _sp_result)

        # Get the name in its native case, in all caps, and all lowercase
        Dependency(GET "${_sp_this}" _sp_name name)
        string(TOUPPER "${_sp_name}" _sp_uc_name)
        string(TOLOWER "${_sp_name}" _sp_lc_name)

        # Add prefix path and XXX_ROOT to the list of paths
        set("${_sp_result}" ${CMAKE_PREFIX_PATH})
        list(APPEND "${_sp_result}" "${${_sp_name}_ROOT}")
        list(APPEND "${_sp_result}" "${${_sp_uc_name}_ROOT}")
        list(APPEND "${_sp_result}" "${${_sp_lc_name}_ROOT}")

        # Possibly some duplicates so clean those up
        list(REMOVE_DUPLICATES "${_sp_result}")

        # Return the paths
        cpp_return("${_sp_result}")
    endfunction()

    #[[[ Attempts to locate the dependency
    #
    #]]
    cpp_member(find_dependency Dependency desc)
    function("${find_dependency}" _fd_this _fd_found)

        # Check if it was already found? If so short-circuit and return TRUE
        Dependency(GET "${_fd_this}" "${_fd_found}" found)
        if("${${_fd_found}}")
            cpp_return("${_fd_found}")
        endif()

        # Wasn't found so call find_package to look for it.
        Dependency(_SEARCH_PATHS "${_fd_this}" _fd_paths)
        Dependency(GET "${_fd_this}" _fd_name name)
        Dependency(GET "${_fd_this}" _fd_version version)
        find_package(
            "${_fd_name}"
            CONFIG
            PATHS "${_fd_paths}"
            NO_PACKAGE_ROOT_PATH
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_PACKAGE_REGISTRY
            NO_CMAKE_SYSTEM_PATH
            NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
        )

        # Is it found now? Record and return the result
        if("${${_fd_name}_FOUND}")
            _cmaize_dependency_check_target("${_fd_this}" "find")
            Dependency(SET "${_fd_this}" found TRUE)
            set("${_fd_found}" TRUE PARENT_SCOPE)
        else()
            set("${_fd_found}" FALSE PARENT_SCOPE)
        endif()
    endfunction()

    #[[[
    # Virtual member to build a dependency.
    #]]
    cpp_member(build_dependency Dependency)
    cpp_virtual_member(build_dependency)

    #[[[
    # Initialize the dependency with project information.
    #]]
    cpp_member(init Dependency args)
    function("${init}" self)

        set(_i_options BUILD_TARGET FIND_TARGET NAME URL VERSION)
        cmake_parse_arguments(_i "" "${_i_options}" "" ${ARGN})

        Dependency(SET "${self}" name "${_i_NAME}")
        Dependency(SET "${self}" location "${_i_URL}")
        Dependency(SET "${self}" version "${_i_VERSION}")
        Dependency(SET "${self}" build_target "${_i_BUILD_TARGET}")
        Dependency(SET "${self}" find_target "${_i_FIND_TARGET}")

    endfunction()
cpp_end_class()

