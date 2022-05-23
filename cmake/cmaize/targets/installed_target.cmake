include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/target)

#[[[
# Wraps a target that is already installed on the system.
#]]
cpp_class(InstalledTarget Target)

    #[[[
    # :type: path
    #
    # The root directory of the installation.
    #]]
    cpp_attr(InstalledTarget root_path)

    #[[[
    # Instantiate a target for a resource that is already installed.
    #
    # :param self: InstalledTarget object
    # :type self: InstalledTarget
    # :param root: The top of the install location for the resource. Must
    #              already exist.
    # :type root: path
    #
    # :returns: ``self`` will be set to the new instance of ``InstalledTarget``
    # :rtype: InstalledTarget
    #
    # :raises DirectoryNotFound: Root directory was not found.
    #]]
    cpp_constructor(CTOR InstalledTarget path)
    function("${CTOR}" self root)

        # Check if the root path exists
        cpp_directory_exists(exists "${root}")
        if(NOT exists)
            set(msg "InstalledTarget root directory not found. ")
            string(APPEND msg "Root given: ${root}")
            cpp_raise(DirectoryNotFound "${msg}")
        endif() 

        InstalledTarget(SET "${self}" root_path "${root}")

    endfunction()

cpp_end_class()
