function(_cpp_find_using_path _cfup_content _cfup_name _cfup_version _cfup_comps
                              _cfup_path)
    #The find_package command only uses CMAKE_PREFIX_PATH
    set(${_cfup_content}
"list(APPEND CMAKE_PREFIX_PATH ${_cfup_path})
find_package(
    ${_cfup_name}
    ${_cfup_version}
    ${_cfup_comps}
    CONFIG
    QUIET
    NO_PACKAGE_ROOT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
)
" PARENT_SCOPE)
endfunction()

function(_cpp_find_using_user_recipe _cfuur_content _cfuur_name _cfuur_version
                                     _cfuur_comps _cfuur_recipe _cfuur_path)
set(${_cfuur_content}
"set(_cfuur_targets \${BUILDSYSTEM_TARGETS})
list(APPEND CMAKE_MODULE_PATH ${_cfuur_recipe})
list(APPEND CMAKE_PREFIX_PATH ${_cfuur_path})
find_package(
    ${_cfuur_name}
    ${_cfuur_version}
    ${_cfuur_comps}
    MODULE
    QUIET
)
list(APPEND _cfuur_targets \${BUILDSYSTEM_TARGETS})
list(LENGTH _cfuur_targets _cfuur_n)
if(\${_cfuur_n} GREATER 0)
    list(REMOVE_DUPLICATES _cfuur_targets)
    list(LENGTH _cfuur_targets _cfuur_n_new)
    if(\${_cfuur_n_new} GREATER 0)
        _cpp_debug_print(\"New targets: \${_cfuur_targets}\")
        return()
    endif()
endif()
add_library(${_cfuur_name} INTERFACE)
string(TOUPPER ${_cfuur_name} _cfuur_NAME)
foreach(_cfuur_inc_var ${_cfuur_name}_INCLUDE_DIRS
                       \${_cfuur_NAME}_INCLUDE_DIRS)
    _cpp_is_not_empty(_cfuur_has_incs \${_cfuur_inc_var})
    if(_cfurr_has_incs)
        target_include_directories(${_cfuur_name} INTERFACE \${_cfuur_inc_var})
    endif()
endforeach()
foreach(_cfuur_lib_var ${_cfuur_name}_LIBRARIES
                       \${_cfuur_NAME}_LIBRARIES)
    _cpp_is_not_empty(_cfuur_has_libs \${_cfuur_lib_var})
    if(_cfurr_has_libs)
        target_link_libraries(${_cfuur_name} INTERFACE \${_cfuur_lib_var})
    endif()
endforeach()
" PARENT_SCOPE)
endfunction()

function(_cpp_find_recipe_dispatch _cfrd_output)
    cpp_parse_arguments(
            _cfrd "${ARGN}"
            OPTION PATH RECIPE NAME VERSION
            LISTS COMPONENTS
            MUST_HAVE NAME
    )
    if(_cfrd_COMPONENTS)
        set(_cfrd_comps "COMPONENTS ${_cfrd_COMPONENTS}")
    endif()
    if(_cfrd_PATH)
        _cpp_find_using_path(
            _cfrd_content
            ${_cfrd_NAME}
            "${_cfrd_VERSION}"
            "${_cfrd_comps}"
            "${_cfrd_PATH}"
        )
    elseif(_cfrd_RECIPE)
        _cpp_find_using_user_recipe(
            _cfrd_content
            ${_cfrd_NAME}
            "${_cfrd_VERSION}"
            "${_cfrd_comps}"
            "${_cfrd_RECIPE}"
        )
    endif()
    file(WRITE ${_cfrd_output} "${_cfrd_content}")
endfunction()
