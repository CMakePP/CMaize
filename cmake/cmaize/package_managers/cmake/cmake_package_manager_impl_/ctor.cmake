include_guard()

# Issue #109, w/o this we get a warning if no languages are enabled
if(ENABLED_LANGUAGES)
    include(GNUInstallDirs)
endif()

macro(_cpm_ctor_impl self)
    PackageManager(SET "${self}" type "CMake")

    # Establish default paths
    if(CMAKE_INSTALL_LIBDIR)
        CMakePackageManager(SET library_prefix "${CMAKE_INSTALL_LIBDIR}")
    else()
        CMakePackageManager(SET library_prefix "lib")
    endif()

    if(CMAKE_INSTALL_BINDIR)
        CMakePackageManager(SET binary_prefix "${CMAKE_INSTALL_BINDIR}")
    else()
        CMakePackageManager(SET binary_prefix "bin")
    endif()

    CMakePackageManager(add_paths "${self}" ${CMAKE_PREFIX_PATH})

    # TODO: Add paths from Dependency(_search_paths if there are any
    #       generalizable ones

    # Initialize the dependency map
    cpp_map(CTOR _ctor_dep_map)
    CMakePackageManager(SET "${self}" dependencies "${_ctor_dep_map}")
endmacro()
