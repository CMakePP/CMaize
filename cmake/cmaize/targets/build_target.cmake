include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/target)

#[[[
# Wraps a target which must be built as part of the build system.
#]]
cpp_class(BuildTarget Target)

    #[[[
    # :type: list of path
    #
    # Paths needed to compile or import.
    #]]
    cpp_attr(BuildTarget include_dirs)

    #[[[
    # :type: list of path
    #
    # Files needed to compile or import.
    #]]
    cpp_attr(BuildTarget include_files)

    #[[[
    # :type: ProjectSpecification
    #
    # The project specification for the current project.
    #]]
    cpp_attr(BuildTarget project_specification)

    #[[[
    # :type: list of BuildTarget
    #
    # Dependencies that need to be built.
    #]]
    cpp_attr(BuildTarget project_dependencies)

    #[[[
    # :type: list of InstalledTarget
    #
    # Dependencies that are already installed.
    #]]
    cpp_attr(BuildTarget system_dependencies)

    #[[[
    # Virtual member function for building the target.
    # 
    # :param self: BuildTarget object
    # :type self: BuildTarget
    #]]
    cpp_member(make_target BuildTarget)
    cpp_virtual_member(make_target)

    #[[[
    # Virtual member function to wrap calls to add_library, add_executable,
    # add_custom_target, etc.
    # 
    # :param self: BuildTarget object
    # :type self: BuildTarget
    #]]
    cpp_member(_create_target BuildTarget)
    cpp_virtual_member(_create_target)

    #[[[
    # Virtual member function to set the include directories for the target.
    # 
    # :param self: BuildTarget object
    # :type self: BuildTarget
    #]]
    cpp_member(_set_include_directories BuildTarget)
    cpp_virtual_member(_set_include_directories)

cpp_end_class()
