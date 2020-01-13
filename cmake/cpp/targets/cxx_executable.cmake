include_guard()
include(cpp/targets/cxx_target)

cpp_class(CXXExecutable CXXTarget)

    cpp_member(_create_target CXXExecutable)
    function("${_create_target}" _ct_this)
        CXXExecutable(GET "${_ct_this}" _ct_name name)
        CXXExecutable(GET "${_ct_this}" _ct_srcs sources)
        add_executable("${_ct_name}" ${_ct_srcs})
    endfunction()

cpp_end_class()
