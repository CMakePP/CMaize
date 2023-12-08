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
