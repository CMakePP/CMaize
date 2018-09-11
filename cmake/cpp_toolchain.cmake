include(cpp_checks) #For _cpp_is_valid
include(cpp_options) #For cpp_option

function(_cpp_write_toolchain_file)
    set(_cwtf_O_kwargs DESTINATION)
    cmake_parse_arguments(_cwtf "" "${_cwtf_O_kwargs}" "" ${ARGN})
    cpp_option(_cwtf_DESTINATION "${CMAKE_BINARY_DIR}")

    set(_cwtf_file ${_cwtf_DESTINATION}/toolchain.cmake)
    set(_cwtf_contents "include(CMakeForceCompiler)")

    #Use the Force compiler to avoid CMake checking the compiler a billion times
    foreach(_cwtf_l C CXX Fortran)
        #In order to get under 80 characters we define a couple variables
        #Will be <Lang>_COMPILER
        set(_cwtf_comp ${_cwtf_l}_COMPILER)
        #Will be CMAKE_<Lang>_COMPILER
        set(_cwtf_cmake CMAKE_${__cwtf_comp})
        #Will be CMAKE_FORCE_<Lang>_COMPILER
        set(_cwtf_cmd CMAKE_FORCE_${_cwtf_comp})
        #Will be CMAKE_<Lang>_COMPILER_ID
        set(_cwtf_id ${_cwtf_cmake}_ID)

        #Did the user set this compiler
        _cpp_valid(_cwtf_is_set ${_cwtf_cmake})
        if(${_cwtf_is_set})
            list(
                APPEND ${_cwtf_contents}
               "${_cwtf_cmd}(${${_cwtf_cmake}} ${${_cwtf_ID}}"
            )
        endif()
    endforeach()


    set(_cwtf_vars
        CMAKE_SYSTEM_NAME #Linux, Darwin, etc.
        CMAKE_MODULE_PATH #Where to look for modules
        BUILD_SHARED_LIBS #Should we build shared libraries?
        CPP_LOCAL_CACHE #Where dependencies will be installed
    )

    set(_cwtf_contents "")
    foreach(_cwtf_var ${_cwtf_vars})
        if("${${_cwtf_var}}" STREQUAL "")
            #Intentionally empty
        else()
            set(_cwtf_line "set(${_cwtf_var} \"${${_cwtf_var}}\")\n")
            set(_cwtf_contents "${_cwtf_contents}${_cwtf_line}")
        endif()
    endforeach()

    file(WRITE ${_cwtf_file} ${_cwtf_contents})
    set(CMAKE_TOOLCHAIN_FILE ${_cwtf_file} PARENT_SCOPE)
endfunction()
