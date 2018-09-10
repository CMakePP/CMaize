include(GNUInstallDirs) #Creates variables for a typical GNU install
include(cpp_options) #For _cpp_option
include(cpp_toolchain) #For writing the toolchain file
set(CPP_ROOT ${CMAKE_CURRENT_LIST_DIR})

macro(CPPMain)
    _cpp_debug_print("CPP Root is: ${CPP_ROOT}")

    #Options user may actually want to control
    cpp_option(CPP_DEBUG_MODE ON)
    cpp_option(CPP_LOCAL_CACHE $ENV{HOME}/.cpp_cache)
    cpp_option(CPP_FIND_RECIPES ${PROJECT_SOURCE_DIR}/cmake/find_external)
    cpp_option(CPP_BUILD_RECIPES ${PROJECT_SOURCE_DIR}/cmake/build_external)
    cpp_option(CMAKE_BUILD_TYPE Debug)
    cpp_option(BUILD_SHARED_LIBS ON)

    #These are options that you shouldn't need to touch
    string(TOLOWER ${PROJECT_NAME} CPP_project_name)
    cpp_option(CPP_NAMESPACE ${CPP_project_name})
    cpp_option(
        CPP_LIBDIR
        ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/${CPP_NAMESPACE}
    )
    cpp_option(
        CPP_BINDIR
        ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}/${CPP_NAMESPACE}
    )
    cpp_option(
        CPP_INCDIR
        ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_INCLUDEDIR}/${CPP_NAMESPACE}
    )
    cpp_option(
        CPP_SHAREDIR ${CMAKE_INSTALL_PREFIX}/share/cmake/${CPP_NAMESPACE}
    )

    #We require all targets to use RPATHs (but only if they aren't system libs)
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

    #Write a toolchain file to forward if the user did not provide one
    if("${CMAKE_TOOLCHAIN_FILE}" STREQUAL "")
        cpp_write_toolchain_file()
    endif()


    #Print out the details of the configuration
    message("Install settings for ${PROJECT_NAME}:")
    message(STATUS "Libraries will be installed to: ${CPP_LIBDIR}")
    message(STATUS "Executables will be installed to: ${CPP_BINDIR}")
    message(STATUS "Includes will be installed to ${CPP_INCDIR}")
    message(STATUS "Config files will be installed to ${CPP_SHAREDIR}")
endmacro()

