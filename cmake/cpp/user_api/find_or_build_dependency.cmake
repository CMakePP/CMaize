include_guard()
include(cpp/dependency/github)

function(cpp_find_or_build_dependency _fobd_name)

    # See if we already registered this dependency, if not register it
    cpp_get_global(_fobd_depend "__CPP_DEPENDENCY_${_fobd_name}__")
    if("${_fobd_depend}" STREQUAL "")
        # TODO: Actually make sure it's from GitHub
        GitHubDependency(CTOR _fobd_depend)

        Dependency(INIT "${_fobd_depend}" NAME "${_fobd_name}" ${ARGN})
        cpp_set_global("__CPP_DEPENDENCY_${_fobd_name}__" "${_fobd_depend}")
    endif()

    Dependency(FIND_DEPENDENCY "${_fobd_depend}" _fobd_found)
    if("${_fobd_found}")
        return()
    endif()

    Dependency(BUILD_DEPENDENCY "${_fobd_depend}")

    Dependency(FIND_DEPENDENCY "${_fobd_depend}" _fobd_found)
    if(NOT "${_fobd_found}")
        message(
            FATAL_ERROR "Still can't find ${_fobd_name}, even after building it"
        )
    endif()
endfunction()
