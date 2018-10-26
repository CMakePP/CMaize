################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include(GNUInstallDirs) #Creates variables for a typical GNU install

#Internal modules needed for CPPMain
include(cpp_checks) #For _cpp_is_empty
include(cpp_options) #For cpp_option
include(cpp_toolchain) #For writing the toolchain file

#These are included for the user's convenience
include(cpp_targets)
include(cpp_dependency)
set(CPP_SRC_DIR ${CMAKE_CURRENT_LIST_DIR})

macro(CPPMain)
    _cpp_debug_print("Using CPP: ${CPP_SRC_DIR}")

    #Options for CPP
    cpp_option(CPP_DEBUG_MODE ON)
    #cpp_option(CPP_INSTALL_CACHE $ENV{HOME}/.cpp_cache)
    cpp_option(CPP_INSTALL_CACHE ${CMAKE_BINARY_DIR}/.cpp_cache)
    cpp_option(CPP_FIND_RECIPES ${PROJECT_SOURCE_DIR}/cmake/find_external)
    cpp_option(CPP_BUILD_RECIPES ${PROJECT_SOURCE_DIR}/cmake/build_external)

    #CMake options that should be considered in some regard
    cpp_option(CMAKE_BUILD_TYPE Debug)
    cpp_option(BUILD_SHARED_LIBS ON)

    #These are options that you shouldn't need to touch
    string(TOLOWER ${PROJECT_NAME} CPP_project_name)
    cpp_option(CPP_NAMESPACE ${CPP_project_name})
    cpp_option(CPP_LIBDIR ${CMAKE_INSTALL_LIBDIR}/${CPP_NAMESPACE})
    cpp_option(CPP_BINDIR ${CMAKE_INSTALL_BINDIR}/${CPP_NAMESPACE})
    cpp_option(CPP_INCDIR ${CMAKE_INSTALL_INCLUDEDIR}/${CPP_NAMESPACE})
    cpp_option(CPP_SHAREDIR share/cmake/${CPP_NAMESPACE})

    #We require all targets to use RPATHs (but only if they aren't system libs)
    set(CMAKE_SKIP_BUILD_RPATH  FALSE)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

    list(
        FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CPP_LIBDIR}"
        _cm_is_system
    )
    if(${_cm_is_system} EQUAL -1)
        SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${CPP_LIBDIR}")
    endif()

    #Write a toolchain file to forward if the user did not provide one
    _cpp_is_empty(_cm_tool CMAKE_TOOLCHAIN_FILE)
    if(_cm_tool)
        _cpp_write_toolchain_file()
    endif()


    #Print out the details of the configuration
    message("Install settings for ${PROJECT_NAME}:")
    message(STATUS "Libraries will be installed to: ${CPP_LIBDIR}")
    message(STATUS "Executables will be installed to: ${CPP_BINDIR}")
    message(STATUS "Includes will be installed to ${CPP_INCDIR}")
    message(STATUS "Config files will be installed to ${CPP_SHAREDIR}")
endmacro()

