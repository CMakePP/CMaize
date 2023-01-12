include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cpp/dependency/dependency)

function(cpp_find_or_build_dependency _fobd_name)

    # See if we already registered this dependency, if not register it
    cpp_get_global(_fobd_depend "__CPP_DEPENDENCY_${_fobd_name}__")
    if("${_fobd_depend}" STREQUAL "")
        # TODO: Actually make sure it's from GitHub
        GitHubDependency(CTOR _fobd_depend)

        Dependency(INIT "${_fobd_depend}" NAME "${_fobd_name}" ${ARGN})
        cpp_set_global("__CPP_DEPENDENCY_${_fobd_name}__" "${_fobd_depend}")
    endif()

    message(STATUS "Attempting to find installed ${_fobd_name}")

    Dependency(FIND_DEPENDENCY "${_fobd_depend}" _fobd_found)
    if("${_fobd_found}")
        message(STATUS "${_fobd_name} installation found")
        return()
    endif()
    
    message(STATUS "Attempting to fetch and build ${_fobd_name}")

    Dependency(BUILD_DEPENDENCY "${_fobd_depend}")

    # The command above will throw build errors from inside FetchContent
    # if the fetch and build fails, so we can assume at this point that
    # it completed successfully
    message(STATUS "${_fobd_name} build complete")

    # Alias the build target as the find_target to unify the API
    Dependency(GET "${_fobd_depend}" _fobd_find_target "find_target")
    Dependency(GET "${_fobd_depend}" _fobd_build_target "build_target")
    if(NOT "${_fobd_find_target}" STREQUAL "${_fobd_build_target}")
        if(TARGET "${_fobd_find_target}")
            return()
        endif()
        add_library("${_fobd_find_target}" ALIAS "${_fobd_build_target}")
    endif()

endfunction()
