include_guard()
include(cmaize/targets/cxx_library)

cpp_class(CXXInterfaceLibrary CXXLibrary)

    #[[[
    # Get the access level for the target.
    #
    # .. note::
    # 
    #    Implements ``CXXTarget(_access_level``.
    #
    # :param self: CXXInterfaceLibrary object
    # :type self: CXXInterfaceLibrary
    # :param _al_result: Return variable holding the access level result.
    # :type _al_result: str*
    #
    # :returns: Access level of the target.
    # :rtype: str
    #]]
    cpp_member(_access_level CXXInterfaceLibrary str)
    function("${_access_level}" self _al_result)

        set("${_al_result}" INTERFACE)
        cpp_return("${_al_result}")
    
    endfunction()

    #[[[
    # Creates the interface library target with ``add_library()``.
    #
    # .. note::
    #
    #    Overrides ``BuildTarget(_create_target``.
    #
    # :param self: CXXInterfaceLibrary object
    # :type self: CXXInterfaceLibrary
    #]]
    cpp_member(_create_target CXXInterfaceLibrary)
    function("${_create_target}" self)

        CXXInterfaceLibrary(target "${self}" _it_name)
        
        add_library("${_it_name}" INTERFACE)

    endfunction()

    #[[[
    # CMake doesn't let interface libraries set their public headers, so
    # this function is a no-op.
    #
    # .. note::
    #
    #    Overrides ``CXXTarget(_set_public_headers``.
    #
    # :param self: CXXInterfaceLibrary object
    # :type self: CXXInterfaceLibrary
    #]]
    cpp_member(_set_public_headers CXXInterfaceLibrary)
    function("${_set_public_headers}" self)
        
    endfunction()
cpp_end_class()
