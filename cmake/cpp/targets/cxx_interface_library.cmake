include_guard()
include(cpp/targets/cxx_library)

cpp_class(CXXInterfaceLibrary CXXLibrary)

    cpp_member(_access_level CXXInterfaceLibrary)
    function("${_access_level}" _al_this _al_result)
        set("${_al_result}" INTERFACE PARENT_SCOPE)
    endfunction()

    cpp_member(_create_target CXXInterfaceLibrary)
    function("${_create_target}" _it_this)
        CXXInterfaceLibrary(GET "${_it_this}" _it_name name)
        add_library("${_it_name}" INTERFACE)
    endfunction()


    cpp_member(_set_public_headers CXXInterfaceLibrary)
    function("${_set_public_headers}" _sph_this)
        # CMake doesn't let interface libraries set their public headers
    endfunction()
cpp_end_class()
