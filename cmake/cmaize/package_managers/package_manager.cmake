include_guard()
include(cmakepp_lang/cmakepp_lang)

include(cmaize/targets/cmaize_target)
include(cmaize/package_managers/get_package_manager)

#[[[
# Base class for the PackageManager class hierarchy.
#]]
cpp_class(PackageManager)

    #[[[
    # :type: desc
    #
    # Type of the package manager being used. Defaults to "None".
    #]]
    cpp_attr(PackageManager type "None")

    #[[[
    # Virtual member to check if the package exists in the package manager.
    #]]
    cpp_member(has_package PackageManager desc PackageSpecification)
    cpp_virtual_member(has_package)

    #[[[
    # Virtual member function to get an installed package target.
    #]]
    cpp_member(find_installed PackageManager desc PackageSpecification)
    cpp_virtual_member(find_installed)

    #[[[
    # Virtual member function to get the package source and prepare a
    # build target.
    #]]
    cpp_member(fetch_package PackageManager desc PackageSpecification)
    cpp_virtual_member(fetch_package)

    #[[[
    # Virtual member to install a package.
    #]]
    cpp_member(install_package PackageManager str args)
    cpp_virtual_member(install_package)

cpp_end_class()

#[[[
# Registers a PackageManager instance. This should only be called at the end
# of the file defining the PackageManager class.
#]]
function(_register_package_manager_base_class)

    PackageManager(CTOR __package_manager)
    register_package_manager("packagemanager" "${__package_manager}")
    
endfunction()

_register_package_manager_base_class()
