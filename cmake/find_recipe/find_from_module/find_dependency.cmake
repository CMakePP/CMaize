include_guard()
include(object/object)
include(find_recipe/handle_found_var)
include(find_recipe/handle_target_vars)

function(_cpp_FindFromModule_find_dependency _cFfd_handle _cFfd_version
                                             _cFfd_comps _cFfd_paths)
    _cpp_Object_get_value(${_cFfd_handle} _cFfd_module module_path)
    _cpp_Object_get_value(${_cFfd_handle} _cFfd_name name)

    #Make sure we can find the find module
    get_filename_component(_cFfd_dir ${_cFfd_module} DIRECTORY)
    set(CMAKE_MODULE_PATH "${_cFfd_dir}" "${CMAKE_MODULE_PATH}")

    list(APPEND CMAKE_PREFIX_PATH ${_cFfd_paths})
    find_package(${_cFfd_name} ${_cFfd_version} ${_cFfd_comps} MODULE QUIET)
    _cpp_FindRecipe_handle_found_var(${_cFfd_handle})
    _cpp_Object_get_value(${_cFfd_handle} _cFfd_was_found found)
    if("${_cFfd_was_found}")
        _cpp_handle_target_vars(${_cFfd_name})
        _cpp_Object_set_value(${_cFfd_handle} paths "${CMAKE_PREFIX_PATH}")
    endif()
endfunction()
