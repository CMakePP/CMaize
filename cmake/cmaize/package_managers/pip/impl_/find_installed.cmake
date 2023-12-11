include_guard()

macro(_pipv_find_installed self _fi_result _fi_package_specs)

    PIPVenv(GET "${self}" _fi_py_exe python_executable)

    # TODO: extract name from package specs

    execute_process(
        COMMAND "${_fi_py_exe}" "-m" "pip" "list"
        COMMAND grep -w "${fpm_module_name}"
        OUTPUT_VARIABLE _fi_matching_modules
    )

    if("${_fi_matching_modules}" STREQUAL "")
        set("${_fi_result}" FALSE PARENT_SCOPE)
    else()
        set("${_fi_result}" TRUE PARENT_SCOPE)
    endif()

endmacro()
