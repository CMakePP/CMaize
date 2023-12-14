include_guard()

#[[[
# Wraps the process of finding Python and working out the version we found.
#
# :param py_exe: Variable which will hold the path to the found Python
#    interpreter.
# :type py_exe: path*
# :param version: The version of the interpreter in the format major.minor.
# :type version: str
#]]
function(find_python _fp_py_exe _fp_version)

    find_package(Python3 COMPONENTS Interpreter QUIET REQUIRED)
    set("${_fp_py_exe}" "${Python3_EXECUTABLE}" PARENT_SCOPE)
    set(
        "${_fp_version}"
        "${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}"
        PARENT_SCOPE
    )

endfunction()

#[[[
# Wraps the process of creating a Python virtual environment
#
# :param venv_dir: Variable to hold the path to the virtual environment
# :type venv_dir: path*
# :param py_exe: The Python executable to use to create the environment.
# :type py_exe: path
# :param name: The name for the virtual environment.
# :type name: str
#]]
function(create_virtual_env _cve_venv_dir _cve_py_exe _cve_name)
    execute_process(
        COMMAND "${_cve_py_exe}" "-m" "venv" "${_cve_name}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    )
    set(
        "${_cve_venv_dir}"
        "${CMAKE_CURRENT_BINARY_DIR}/${_cve_name}"
        PARENT_SCOPE
    )
endfunction()
