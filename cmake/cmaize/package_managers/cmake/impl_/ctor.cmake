# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard()

macro(_cpm_ctor_impl self)
    # Issue #109, w/o this we get a warning if no languages are enabled
    get_property(_cpm_languages GLOBAL PROPERTY ENABLED_LANGUAGES)
    if(NOT "${_cpm_languages}" EQUAL "NONE")
        include(GNUInstallDirs)
    endif()

    PackageManager(SET "${self}" type "cmake")

    # Establish default paths
    if(CMAKE_INSTALL_LIBDIR)
        CMakePackageManager(
            SET "${self}" library_prefix "${CMAKE_INSTALL_LIBDIR}"
        )
    else()
        CMakePackageManager(SET "${self}" library_prefix "lib")
    endif()

    if(CMAKE_INSTALL_BINDIR)
        CMakePackageManager(
            SET "${self}" binary_prefix "${CMAKE_INSTALL_BINDIR}"
        )
    else()
        CMakePackageManager(SET "${self}" binary_prefix "bin")
    endif()

    CMakePackageManager(add_paths "${self}" ${CMAKE_PREFIX_PATH})

    # TODO: Add paths from Dependency(_search_paths if there are any
    #       generalizable ones

    # Initialize the dependency map
    cpp_map(CTOR _ctor_dep_map)
    CMakePackageManager(SET "${self}" dependencies "${_ctor_dep_map}")
endmacro()
