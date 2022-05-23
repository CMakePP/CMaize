include_guard()
include(cmakepp_lang/cmakepp_lang)

#[[[
# Wraps a target that is already installed on the system.
#]]
cpp_class(InstalledTarget)

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
    # :param root: The top of the install location for the resource.
    # :type root: path
    #
    # :returns: ``self`` will be set to the new instance of ``InstalledTarget``
    # :rtype: InstalledTarget
    #]]
    cpp_constructor(CTOR InstalledTarget path)
    function("${CTOR}" self root)

        # Maybe check if the root path exists here?

        InstalledTarget(SET "${self}" root_path "${root}")

    endfunction()

cpp_end_class()
