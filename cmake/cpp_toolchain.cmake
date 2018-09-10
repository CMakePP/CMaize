include(cpp_checks) #For _cpp_is_valid

function(cpp_write_toolchain_file)
    set(_cwtf_file ${CMAKE_BINARY_DIR}/toolchain.cmake)
    set(_cwtf_vars
        CMAKE_SYSTEM_NAME #Linux, Darwin, etc.
        CMAKE_C_COMPILER #C compiler
        CMAKE_CXX_COMPILER #C++ compiler
        CMAKE_MODULE_PATH #Where to look for modules
        BUILD_SHARED_LIBS #Should we build shared libraries?
        CPP_LOCAL_CACHE #Where dependencies will be installed
    )

    set(_cwtf_contents "")
    foreach(_cwtf_var ${_cwtf_vars})
        if("${_cwtf_var}" STREQUAL "")
            #Intentionally empty
        else()
            set(_cwtf_line "set(${_cwtf_var} \"${${_cwtf_var}}\")\n")
            set(_cwtf_contents "${_cwtf_contents}${_cwtf_line}")
        endif()
    endforeach()

    file(WRITE ${_cwtf_file} ${_cwtf_contents})
    set(CMAKE_TOOLCHAIN_FILE ${_cwtf_file} PARENT_SCOPE)
endfunction()
