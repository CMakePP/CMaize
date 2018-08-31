include(GNUInstallDirs) #Creates variables for a typical GNU install
include(cpp_options)
macro(CPPMain)
    #Options user may actually want to control
    _cpp_option(CPP_DEBUG_MODE ON)
    _cpp_option(CPP_LOCAL_PREFIX $ENV{HOME}/.cpp_cache)
    _cpp_option(CMAKE_BUILD_TYPE Debug)

    #These are options that you shouldn't need to touch
    _cpp_option(CPP_LIBDIR ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR})
    _cpp_option(CPP_BINDIR ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR})
    _cpp_option(CPP_INCDIR ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_INCLUDEDIR})
    _cpp_option(CPP_SHAREDIR ${CMAKE_INSTALL_PREFIX}/share)

    #We require all targets to use RPATHs
    set(CMAKE_SKIP_BUILD_RPATH  FALSE)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

    list(
        FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CPP_LIBDIR}"
        _cm_is_system
    )
    if(${_cm_is_system} EQUAL -1)
        SET(CMAKE_INSTALL_RPATH "${CPP_LIBDIR}/${PROJECT_NAME}")
    endif()

    string(TOLOWER ${PROJECT_NAME} CPP_project_name)
    message(STATUS "Libraries will be installed to: ${CPP_LIBDIR}")
    message(STATUS "Executables will be installed to: ${CPP_BINDIR}")
    message(STATUS "Includes will be installed to ${CPP_INCDIR}")
    message(
        STATUS
        "${CPP_project_name}Config files will be installed to ${CPP_SHAREDIR}"
    )
endmacro()

