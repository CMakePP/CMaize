include(cpp_checks) #For _cpp_is_valid
include(cpp_options) #For cpp_option

function(_cpp_write_toolchain_file)
    set(_cwtf_O_kwargs DESTINATION)
    cmake_parse_arguments(_cwtf "" "${_cwtf_O_kwargs}" "" ${ARGN})
    cpp_option(_cwtf_DESTINATION "${CMAKE_BINARY_DIR}")

    set(_cwtf_file ${_cwtf_DESTINATION}/toolchain.cmake)
    set(_cwtf_contents)

    set(_cwtf_vars
        CMAKE_C_COMPILER
        CMAKE_CXX_COMPILER
        CMAKE_Fortran_COMPILER
        CMAKE_SYSTEM_NAME #Linux, Darwin, etc.
        CMAKE_MODULE_PATH #Where to look for modules
        BUILD_SHARED_LIBS #Should we build shared libraries?
        CPP_LOCAL_CACHE #Where dependencies will be installed
    )

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
