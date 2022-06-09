include_guard()
include(cmaize/targets/cxx_target)

cpp_class(CXXExecutable CXXTarget)

    #[[[
    # Creates the executable target with ``add_executable()``.
    #
    # .. note::
    #
    #    Overrides ``CXXTarget(_create_target``.
    #
    # :param self: CXXExecutable object
    # :type self: CXXExecutable
    #]]
    cpp_member(_create_target CXXExecutable)
    function("${_create_target}" self)
        
        CXXExecutable(target "${self}" _ct_name)
        
        add_executable("${_ct_name}")

    endfunction()

cpp_end_class()
