include_guard()

include(cpp/targets/targets)

function(cpp_add_library _acl_name)
    set(_acl_options SOURCE_DIR INCLUDE_DIR)

    cmake_parse_arguments(_acl "" "${_acl_options}" "" ${ARGN})

    # TODO: Actually establish that we are making a C++ library

    file(GLOB_RECURSE _acl_src
         LIST_DIRECTORIES FALSE
         CONFIGURE_DEPENDS
         "${_acl_SOURCE_DIR}/*.cpp"
         )
    file(GLOB_RECURSE _acl_incs
         LIST_DIRECTORIES FALSE
         CONFIGURE_DEPENDS
         "${_acl_INCLUDE_DIR}/*.hpp"
         )

    list(LENGTH _acl_src _acl_src_n)

    if("${_acl_src_n}" GREATER 0)
        CXXLibrary(CTOR _acl_library)
    else()
        CXXInterfaceLibrary(CTOR _acl_library)
    endif()


    CXXLibrary(
        MAKE_TARGET "${_acl_library}"
        NAME "${_acl_name}"
        INCLUDES "${_acl_incs}"
        SOURCES "${_acl_src}"
        ${ARGN}
    )
endfunction()
