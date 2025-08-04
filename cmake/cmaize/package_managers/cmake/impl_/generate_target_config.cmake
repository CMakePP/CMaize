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

macro(_cpm_generate_target_config_impl
    self
    __gtc_tgt_obj
    __gtc_target_name
    __gtc_namespace
    __gtc_config_file
    __gtc_install_dest
)

    _cmaize_generated_by_cmaize(__gtc_file_contents)
    string(APPEND __gtc_file_contents "\n")

    string(APPEND
        __gtc_file_contents
        "
if(TARGET ${__gtc_namespace}${__gtc_target_name})
    return()
endif()"
    )
    string(APPEND __gtc_file_contents "\n\n")

    string(APPEND
        __gtc_file_contents
        "get_filename_component(PACKAGE_PREFIX_DIR "
        "\"\${CMAKE_CURRENT_LIST_DIR}/../../..\" ABSOLUTE)\n"
    )

    # Create IMPORTED library of the correct type
    CMaizeLibrary(GET "${__gtc_tgt_obj}" __gtc_lib_type type)
    string(APPEND
        __gtc_file_contents
        "
# Create imported target ${__gtc_namespace}${__gtc_target_name}
add_library(${__gtc_namespace}${__gtc_target_name} ${__gtc_lib_type} IMPORTED)
")

    # ----- Start collecting interface target properties -----
    string(APPEND
        __gtc_file_contents
        "
set_target_properties(${__gtc_namespace}${__gtc_target_name}
    PROPERTIES"
    )

    # Add compile features
    CXXTarget(GET "${__gtc_tgt_obj}" __gtc_cxx_std cxx_standard)
    if(NOT "${__gtc_cxx_std}" STREQUAL "")
        string(APPEND
            __gtc_file_contents
            "
        INTERFACE_COMPILE_FEATURES \"cxx_std_${__gtc_cxx_std}\""
        )
    endif()

    # Add include directories
    # TODO: This should not be hard coded!
    string(APPEND
        __gtc_file_contents
        "
        INTERFACE_INCLUDE_DIRECTORIES \"\${PACKAGE_PREFIX_DIR}/include\""
    )

    string(APPEND
        __gtc_file_contents
        "
        # TODO: Handle different configurations (Release, Debug, etc.)
        # Import target \"${__gtc_namespace}${__gtc_target_name}\" for configuration \"???\"
        IMPORTED_CONFIGURATIONS RELEASE"
    )

    # Collect interface link libraries
    BuildTarget(GET "${__gtc_tgt_obj}" __gtc_dep_list depends)
    set(__gtc_interface_link_libraries)
    foreach(__gtc_dep_i ${__gtc_dep_list})
        CMakePackageManager(GET "${self}" __gtc_dep_map dependencies)
        cpp_map(KEYS "${__gtc_dep_map}" __gtc_keys)
        cpp_map(GET "${__gtc_dep_map}" __gtc_dep_obj "${__gtc_dep_i}")

        if("${__gtc_dep_obj}" STREQUAL "")
            continue()
        endif()

        Dependency(GET
            "${__gtc_dep_obj}" __gtc_dep_find_tgt_name find_target
        )
        list(APPEND __gtc_interface_link_libraries ${__gtc_dep_find_tgt_name})
    endforeach()

    # Add interface link libraries
    list(LENGTH __gtc_interface_link_libraries __gtc_link_library_count)
    if("${__gtc_link_library_count}" GREATER 0)
        string(APPEND
            __gtc_file_contents
            "
        INTERFACE_LINK_LIBRARIES \"${__gtc_interface_link_libraries}\""
        )
    endif()

    # ----- End of collecting interface properties -----
    string(APPEND
        __gtc_file_contents
        "
)"
    )

    # TODO: Are there other library types allowed here? Should this condition
    #       instead be 'NOT "${__gtc_lib_type}" STREQUAL "INTERFACE"'?
    if("${__gtc_lib_type}" STREQUAL "SHARED" OR "${__gtc_lib_type}" STREQUAL "STATIC")
        # Based on the shared library suffix, generate the correct versioned
        # library name and soname that CMake will install
        CMaizeTarget(get_property "${__gtc_tgt_obj}" __gtc_version VERSION)
        CMaizeTarget(get_property "${__gtc_tgt_obj}" __gtc_so_version SOVERSION)

        if ("${CMAKE_SHARED_LIBRARY_SUFFIX}" STREQUAL ".so")
            set(__gtc_libname_w_version
                "lib${__gtc_target_name}.so.${__gtc_version}"
            )
            set(__gtc_soname "lib${__gtc_target_name}.so.${__gtc_so_version}")
        elseif("${CMAKE_SHARED_LIBRARY_SUFFIX}" STREQUAL ".dylib")
            set(__gtc_libname_w_version
                "lib${__gtc_target_name}.${__gtc_version}.dylib"
            )
            set(__gtc_soname
                "lib${__gtc_target_name}.${__gtc_so_version}.dylib"
            )
        elseif("${CMAKE_SHARED_LIBRARY_SUFFIX}" STREQUAL ".dll")
            set(__gtc_libname_w_version
                "${__gtc_target_name}.${__gtc_version}.dll"
            )
            set(__gtc_soname
                "${__gtc_target_name}.${__gtc_so_version}.dll"
            )
        else()
            string(APPEND __gtc_msg "Shared libraries with the")
            string(APPEND __gtc_msg "${CMAKE_SHARED_LIBRARY_SUFFIX} suffix")
            string(APPEND __gtc_msg "are not supported yet.")
            cpp_raise(
                UnsupportedLibraryType
                "${__gtc_msg}"
            )
        endif()
    endif()

    # Populate properties about exported objects if any are created
    if("${__gtc_lib_type}" STREQUAL "SHARED" OR "${__gtc_lib_type}" STREQUAL "STATIC")
        CMakePackageManager(GET "${self}" __gtc_lib_prefix library_prefix)
        string(APPEND
            __gtc_file_contents
            "
set(_CMAIZE_IMPORT_LOCATION \"\${PACKAGE_PREFIX_DIR}/${__gtc_lib_prefix}/${__gtc_target_name}/${__gtc_libname_w_version}\")

set_target_properties(${__gtc_namespace}${__gtc_target_name}
    PROPERTIES
        IMPORTED_LOCATION_RELEASE \"\${_CMAIZE_IMPORT_LOCATION}\"
        IMPORTED_SONAME_RELEASE \"${__gtc_soname}\"
)\n"
        )
    endif()

    string(APPEND
        __gtc_file_contents
        "
# Unset variables used
set(PACKAGE_PREFIX_DIR)
set(_CMAIZE_IMPORT_LOCATION)"
    )

    # Write the config file *.in variant
    set(__gtc_config_file_in "${__gtc_config_file}.in")
    file(WRITE "${__gtc_config_file_in}" "${__gtc_file_contents}")

    # Configure the file so it is ready for installation
    configure_package_config_file(
        "${__gtc_config_file_in}"
        "${__gtc_config_file}"
        INSTALL_DESTINATION
            "${__gtc_install_dest}"
    )

    # Install config file
    install(
        FILES "${__gtc_config_file}"
        DESTINATION "${__gtc_install_dest}"
    )

endmacro()
