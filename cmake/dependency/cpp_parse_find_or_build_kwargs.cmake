include_guard()

function(_cpp_parse_find_kwargs)
    set(${_cpfk_toggles} OPTIONAL)
    set(
       ${_cpfk_options}
       NAME TOOLCHAIN CPP_CACHE VERSION RESULT FIND_MODULE BUILD_MODULE
    )
    set(${_cpfk_lists} COMPONENTS)
endfunction()


function(_cpp_parse_build_or_find_kwargs)
    set(${_cpbofk_toggles} PRIVATE)
    set(${_cpbofk_options} NAME TOOLCHAIN CPP_CACHE VERSION RESULT FIND_MODULE
                           BUILD_MODULE URL BRANCH BINARY_DIR SOURCE_DIR
    )
    set(${_cpbofk_lists} COMPONENTS)
endfunction()
