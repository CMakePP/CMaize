include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/target)

#[[[
# CMake package manager going through ``find_package`` and ``FetchContent``.
#]]
cpp_class(CMakePackageManager PackageManager)

    #[[[
    # :type: List[path]
    #
    # Search paths for ``find_package``. It is limited to only these paths.
    #]]
    cpp_attr(CMakePackageManager search_paths)

    #[[[
    # Adds a new search path for the package manager.
    #
    # These paths are stored in the ``search_paths`` attribute. Duplicate
    # paths will be ignored.
    #
    # :param _ap_paths: Paths to add to the search path.
    # :type _ap_paths: List[path]
    #]]
    cpp_member(add_package CMakePackageManager list)
    function("${add_package}" self _ap_paths)

        CMakePackageManager(GET "${self}" _ap_search_paths search_paths)

        foreach(_ap_path ${_ap_paths})
            list(FIND _ap_search_paths "${_ap_path}" found_result)

            # Only add the new path to the search path list if it does not
            # already exist in the search path
            if (NOT found_result EQUAL -1)
                list(APPEND "${self}" _ap_search_paths "${_ap_path}")
            endif()
        endforeach()

        CMakePackageManager(SET "${self}" search_paths _ap_search_paths)

    endfunction()

    #[[[
    # Virtual member to check if the package exists in the package manager.
    #]]
    cpp_member(has_package PackageManager bool ProjectSpecification)
    cpp_virtual_member(has_package)

    #[[[
    # Virtual member function to get the package using the package manager.
    #]]
    cpp_member(get_package PackageManager InstalledTarget ProjectSpecification)
    cpp_virtual_member(get_package)

    #[[[
    # Virtual member to install a package.
    #]]
    cpp_member(install_package PackageManager Target)
    cpp_virtual_member(install_package)

cpp_end_class()
