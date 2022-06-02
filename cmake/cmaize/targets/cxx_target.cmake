include_guard()
include(CheckLanguage)
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/build_target)

#[[[
# Wraps a target which must be built as part of the build system.
#]]
cpp_class(CXXTarget BuildTarget)

    #[[[
    # :type: str
    #
    # CXX standard to use.
    #]]
    cpp_attr(CXXTarget cxx_standard)

    #[[[
    # :type: path
    #
    # Directory containing source code files.
    #]]
    cpp_attr(CXXTarget source_dir)

    #[[[
    # :type: list of path
    #
    # Source files.
    #]]
    cpp_attr(CXXTarget source_files)

    #[[[
    # Construct a ``CXXTarget`` object. This ctor enables the CXX language
    # if it has not already been enabled.
    #
    # .. warning::
    #    
    #    If an existing CMake target name is provided, the CXX language must
    #    already be enabled upon creation of the CMake target, otherwise it
    #    will not have the correct properties.
    # 
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_constructor(CTOR CXXTarget str)
    function("${CTOR}" self tgt_name)

        # Call the parent ctor
        Target(CTOR "${self}" "${tgt_name}")

        # Make sure the CXX language has been enabled
        check_language(CXX)
        if(CMAKE_CXX_COMPILER)
            enable_language(CXX)
        else()
            message(STATUS "No CXX support")
        endif()

    endfunction()

    #[[[
    # Abstracts out CMake's access level concept (public, interface, or 
    # private).
    # 
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_member(_access_level CXXTarget)
    cpp_virtual_member(_access_level)

    #[[[
    # Sets the CXX standard and other compiler features.
    # 
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_member(_set_compile_features CXXTarget)
    function("${_set_compile_features}" self)

        Target(target "${self}" tgt_name)
        CXXTarget(GET "${self}" standard cxx_standard)

        # Call CMake's 'target_compile_features()'
        target_compile_features("${tgt_name}" PUBLIC "${standard}")

    endfunction()

    #[[[
    # Virtual member function to set the include directories for the target.
    # 
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_member(_set_include_directories CXXTarget)
    cpp_virtual_member(_set_include_directories)

cpp_end_class()
