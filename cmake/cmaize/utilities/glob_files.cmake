include_guard()
include(cmakepp_lang/cmakepp_lang)

function(_cmaize_glob_files _cgf_return_files _cgf_dirs _cgf_file_exts)

    set("${_cgf_return_files}" "")
    foreach(_cgf_dir_i ${_cgf_dirs})
        foreach(_cgf_ext_i ${_cgf_file_exts})
            file(GLOB_RECURSE _cgf_files_tmp
                LIST_DIRECTORIES false
                CONFIGURE_DEPENDS
                "${_cgf_dir_i}/*.${_cgf_ext_i}"
            )
            list(APPEND "${_cgf_return_files}" ${_cgf_files_tmp})
        endforeach()
    endforeach()

    cpp_return("${_cgf_return_files}")

endfunction()
