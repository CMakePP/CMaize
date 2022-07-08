include_guard()
include(cmaize/targets/cxx_target)

cpp_class(CXXLibrary CXXTarget)

    #[[[
    # Creates the library target with ``add_library()``.
    #
    # Creates a ``STATIC`` or ``SHARED`` library based on if the variable
    # ``BUILD_SHARED_LIBS`` is ``ON``.
    # 
    # .. note::
    #
    #    Overrides ``BuildTarget(_create_target``.
    #
    # :param self: CXXLibrary object
    # :type self: CXXLibrary
    #]]
    cpp_member(_create_target CXXLibrary)
    function("${_create_target}" self)

        CXXLibrary(target "${self}" _ct_name)

        add_library("${_ct_name}")

    endfunction()

cpp_end_class()


