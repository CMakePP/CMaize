include_guard()

cpp_class(PIP PackageManager)
cpp_end_class()

function(_register_package_manager_pip)

    PIP(CTOR __package_manager)
    register_package_manager("python" "${__package_manager}")

endfunction()
