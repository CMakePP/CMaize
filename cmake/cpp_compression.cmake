include_guard()
include(cpp_assert)
include(cpp_print)

function(_cpp_tar_directory _ctd_output _ctd_dir2tar)
    _cpp_assert_is_directory("${_ctd_dir2tar}")

    #By default when you tar /a/long/path/to/here the directory you see
    #when you untar the tarball is /, inside of which is "a", then "long", ...
    #We actually want the directory you see to be "here"
    #Solution, run tar command in /a/long/path/to on "here"
    get_filename_component(_ctd_work_dir "${_ctd_dir2tar}" DIRECTORY)
    get_filename_component(_ctd_dir "${_ctd_dir2tar}" NAME)

    _cpp_debug_print("Tarring ${_ctd_dir2tar} into ${_ctd_output}.")
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar "cfz" "${_ctd_output}" "${_ctd_dir}"
        WORKING_DIRECTORY ${_ctd_work_dir}
    )
endfunction()

function(_cpp_download_tarball _cdt_output _cdt_url)
    _cpp_debug_print("Getting tarball from URL: ${_cdt_URL}")
    file(DOWNLOAD "${_cdt_url}" "${_cdt_output}")
endfunction()

function(_cpp_untar_directory _cud_tar _cud_destination)
    _cpp_assert_exists(${_cud_tar})

    #Untar inside a clean buffer directory so we can figure out what we got
    string(RANDOM _cud_prefix)
    set(_cud_buffer_dir ${_cud_destination}/${_cud_prefix})
    file(MAKE_DIRECTORY ${_cud_buffer_dir})
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar "xzf" "${_cud_tar}"
        WORKING_DIRECTORY ${_cud_buffer_dir}
    )

    #Figure out what we got and err if it's not a single directory
    file(GLOB _cud_tar_files "${_cud_buffer_dir}/*")
    list(LENGTH _cud_tar_files _cud_nfiles)
    _cpp_debug_print(
        "Tarball contained ${_cud_nfiles} files: ${_cud_tar_files}."
    )

    if(_cud_nfiles LESS 1)
        message(FATAL_ERROR "The tarball was empty")
    elseif(_cud_nfiles GREATER 1)
        message(FATAL_ERROR "The tarball contained more than 1 thing.")
    endif()
    list(GET _cud_tar_files 0 _cud_dir)
    _cpp_assert_is_directory(${_cud_dir})

    #Copy contents of the single directory to the destination
    file(GLOB _cud_files "${_cud_dir}/*")
    foreach(_cud_file_i ${_cud_files})
        get_filename_component(_cud_file_j ${_cud_file_i} NAME)
        file(RENAME ${_cud_file_i} ${_cud_destination}/${_cud_file_j})
    endforeach()
    file(REMOVE "${_cud_buffer_dir}")
endfunction()
