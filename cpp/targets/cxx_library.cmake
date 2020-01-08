include_guard()

function(cpp_add_cxx_library _acl_name _acl_src_dir _acl_inc_dir)
    set(_acl_options SOURCE_DIR INCLUDE_DIR)
    cmake_parse_arguments(_acl "" "${_acl_options}" "" ${ARGN})

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
    get_filename_component(_acl_inc_dir "${_acl_INCLUDE_DIR}" DIRECTORY)
    list(LENGTH _acl_src _acl_src_n)

    if("${_acl_src_n}" GREATER 0)
        add_library("${_acl_name}" "${_acl_src}")
        set_target_properties(
                "${_acl_name}" PROPERTIES PUBLIC_HEADER "${_acl_incs}"
        )
        target_include_directories(
                ${_acl_name}
                PUBLIC
                $<BUILD_INTERFACE:${_acl_inc_dir}>
                $<INSTALL_INTERFACE:include>
        )
    else()
        add_library("${_acl_name}" INTERFACE)
        target_include_directories(
                ${_acl_name}
                INTERFACE
                $<BUILD_INTERFACE:${_acl_inc_dir}>
                $<INSTALL_INTERFACE:include>
        )
    endif()

endfunction()
