include_guard()
include(cpp/targets/cxx_target)

cpp_class(CXXLibrary CXXTarget)

    cpp_member(_create_target CXXLibrary)
    function("${_create_target}" _it_this)
        CXXLibrary(GET "${_it_this}" _it_name name)
        CXXLibrary(GET "${_it_this}" _it_src sources)
        add_library("${_it_name}" "${_it_src}")
    endfunction()

cpp_end_class()


