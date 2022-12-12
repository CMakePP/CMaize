include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/target)

#[[[
# Base class for the PackageManager class hierarchy.
#]]
cpp_class(PackageManager)

    #[[[
    # :type: desc
    #
    # Name of the package manager being used.
    #]]
    cpp_attr(PackageManager name)

    #[[[
    # Virtual member to check if the package exists in the package manager.
    #]]
    cpp_member(has_package PackageManager desc ProjectSpecification)
    cpp_virtual_member(has_package)

    #[[[
    # Virtual member function to get an installed package target.
    #]]
    cpp_member(find_installed PackageManager desc ProjectSpecification)
    cpp_virtual_member(find_installed)

    #[[[
    # Virtual member function to get the package source and prepare a
    # build target.
    #]]
    cpp_member(fetch_package PackageManager desc ProjectSpecification)
    cpp_virtual_member(fetch_package)

    #[[[
    # Virtual member to install a package.
    #]]
    cpp_member(install_package PackageManager Target)
    cpp_virtual_member(install_package)

cpp_end_class()
