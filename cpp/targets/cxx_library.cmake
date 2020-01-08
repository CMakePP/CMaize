include_guard()

function(cpp_add_cxx_library _acl_name _acl_dir)
    file(GLOB_RECURSE _acl_src
         LIST_DIRECTORIES FALSE
         CONFIGURE_DEPENDS
         *.cpp
    )
    file(GLOB_RECURSE _acl_incs
         LIST_DIRECTORIES FALSE
         CONFIGURE_DEPENDS
         *.hpp
    )
endfunction()
