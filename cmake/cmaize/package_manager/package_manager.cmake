include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/target)

#[[[
# 
#]]
cpp_class(PackageManager)

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
