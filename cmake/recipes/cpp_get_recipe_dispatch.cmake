include_guard()
include(recipes/cpp_url_dispatcher)

function(_cpp_get_recipe_dispatch _cgrd_return)
    cpp_parse_arguments(_cgrd "${ARGN}" OPTIONS URL SOURCE_DIR)
    set(_cgrd_header "function(_cpp_get_recipe _cgr_tar _cgr_version)")
    set(_cgrd_footer "endfunction()")

    #Get the file's contents
    if(_cgrd_URL)
        _cpp_url_dispatcher(
            _cgrd_body "${_cgrd_URL}" ${_cgrd_UNPARSED_ARGUMENTS}
        )
    elseif(_cgrd_SOURCE_DIR)
        set(_cgrd_body "_cpp_tar_directory(\${_cgr_tar} ${_cgrd_SOURCE_DIR})")
    else()
        _cpp_error(
            "Not sure how to get source for dependency."
            "Troubleshooting: Did you specify URL or SOURCE_DIR?"
        )
    endif()
    set(
        ${_cgrd_return}
        "${_cgrd_header}\n${_cgrd_body}\n${_cgrd_footer}"
        PARENT_SCOPE
    )
endfunction()
