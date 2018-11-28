include(cpp_cmake_helpers)
include(cpp_checks)

set(test_number 1)

function(_cpp_add_test)
    cpp_parse_arguments(
        _cat "${ARGN}"
        TOGGLES SHOULD_FAIL
        OPTIONS REASON TITLE
        LISTS CONTENTS
        MUST_SET TITLE CONTENTS
    )

    if(_cat_SHOULD_FAIL)
        set(_cat_can_fail CAN_FAIL)
    endif()
    foreach(_cat_cmd_i ${_cat_CONTENTS})
        set(_cat_commands "${_cat_commands}\n${_cat_cmd_i}")
    endforeach()
    _cpp_run_sub_build(
        ${test_prefix}/${test_number}
        NAME ${test_number}
        NO_INSTALL
        ${_cat_can_fail}
        RESULT _cat_result
        OUTPUT _cat_output
        CONTENTS "set(CPP_DEBUG_MODE ON)\n${_cat_commands}"
    )

    #Report status to the user
    #We get back 0 if there's no errors so result=true means we had an error
    set(_cat_passed TRUE)
    if(_cat_SHOULD_FAIL)
        if(_cat_result AND _cat_REASON) #Did it crashed for the right reason?
            _cpp_contains(_cat_reason_met "${_cat_REASON}" "${_cat_output}")
            if(NOT _cat_reason_met)
                set(_cat_passed FALSE)
            endif()
        elseif(_cat_result)
            #Okay crashed like it was supposed to, but no reason to check
        else() #Passed, but it wasn't supposed to
            set(_cat_passed FALSE)
        endif()
    endif()

    #Print the result
    set(_cat_result_msg "${_cat_TITLE} ..................")
    if(_cat_passed)
        message("${_cat_result_msg}passed")
    else()
        message("${_cat_result_msg}***failed")
        message(FATAL_ERROR "Output:\n\n${_cat_output}")
    endif()

    math(EXPR test_number "${test_number} + 1")
    set(test_number "${test_number}" PARENT_SCOPE)
endfunction()

function(_cpp_make_random_dir _cmrd_result _cmrd_prefix)
    string(RANDOM _cmrd_random_prefix)
    set(${_cmrd_result} ${_cmrd_prefix}/${_cmrd_random_prefix} PARENT_SCOPE)
    file(MAKE_DIRECTORY ${_cmrd_prefix}/${_cmrd_random_prefix})
endfunction()

function(_cpp_dummy_cxx_library _cdcl_prefix)
    file(WRITE ${_cdcl_prefix}/a.hpp "int a_fxn();")
    file(
        WRITE ${_cdcl_prefix}/a.cpp
        "#include \"a.hpp\"\nint a_fxn(){return 2;}"
    )
endfunction()

function(_cpp_dummy_cxx_executable _cdce_prefix)
    file(WRITE ${_cdce_prefix}/main.cpp "int main(){return 2;}")
endfunction()

function(_cpp_dummy_cxx_package _cdcp_prefix)
    set(_cdcp_O_kwargs NAME)
    cmake_parse_arguments(
            _cdcp
            ""
            "${_cdcp_O_kwargs}"
            ""
            ${ARGN}
    )
    cpp_option(_cdcp_NAME dummy)
    set(_cdcp_root ${_cdcp_prefix}/${_cdcp_NAME})
    _cpp_dummy_cxx_library(${_cdcp_root})
    _cpp_write_list(
        ${_cdcp_root}
        NAME ${_cdcp_NAME}
        CONTENTS "include(cpp_targets)"
                 "cpp_add_library("
                 "  ${_cdcp_NAME}"
                 "  SOURCES  a.cpp"
                 "  INCLUDES a.hpp"
                 ")"
                 "cpp_install(TARGETS ${_cdcp_NAME})"
    )
endfunction()

function(_cpp_install_dummy_cxx_package _cidcp_prefix)
    cmake_parse_arguments(_cidcp "" "NAME" "" ${ARGN})
    cpp_option(_cidcp_NAME dummy)
    set(_cidcp_root ${_cidcp_prefix}/${_cidcp_NAME})
    _cpp_dummy_cxx_package(${_cidcp_prefix} NAME ${_cidcp_NAME})
    _cpp_run_sub_build(
        ${_cidcp_root}
        INSTALL_DIR ${_cidcp_prefix}/install
        NAME ${_cidcp_NAME}
    )
    #Sanity check
    set(_cidcp_path ${_cidcp_prefix}/install/share/cmake)
    _cpp_assert_exists(
        ${_cidcp_path}/${_cidcp_NAME}/${_cidcp_NAME}-config.cmake
    )
endfunction()

function(_cpp_naive_install_cxx_package _cnicp_prefix)
    cpp_option(_cnicp_NAME dummy)
    set(_cnicp_root ${_cnicp_prefix}/${_cnicp_NAME})
    _cpp_dummy_cxx_library(${_cnicp_root})
    set(_cnicp_install ${_cnicp_prefix}/install)
    _cpp_write_list(
        ${_cnicp_root}
        NAME dummy
        CONTENTS "add_library(dummy a.cpp)"
                 "install("
                 "   TARGETS dummy"
                 "   LIBRARY DESTINATION ${_cnicp_install}/lib"
                 "   ARCHIVE DESTINATION ${_cnicp_install}/lib"
                 ")"
                "install(FILES a.hpp DESTINATION ${_cnicp_install}/include)"
    )
    _cpp_run_sub_build(
        ${_cnicp_root}
        INSTALL_DIR ${_cnicp_install}
        NAME ${_cnicp_NAME}
    )
    _cpp_assert_exists(
        ${_cnicp_install}/include/a.hpp
    )
endfunction()

function(_cpp_make_test_toolchain _cmtt_prefix)
    file(READ ${CMAKE_TOOLCHAIN_FILE} _cmtt_file)
    string(REGEX REPLACE "\n" ";" _cmtt_file "${_cmtt_file}")
    set(_cmtt_new_file)
    foreach(_cmtt_line ${_cmtt_file})
        string(FIND "${_cmtt_line}" "set(CPP_INSTALL_CACHE"  _cmtt_is_cache)
        if("${_cmtt_is_cache}" STREQUAL "-1")
            list(APPEND _cmtt_new_file "${_cmtt_line}")
        else()
            list(
                APPEND
                _cmtt_new_file
                "set(CPP_INSTALL_CACHE \"${_cmtt_prefix}/cpp_cache\")"
            )
        endif()
    endforeach()
    string(REGEX REPLACE ";" "\n" _cmtt_new_file "${_cmtt_new_file}")
    file(WRITE "${_cmtt_prefix}/toolchain.cmake" "${_cmtt_new_file}")
    set(CMAKE_TOOLCHAIN_FILE "${_cmtt_prefix}/toolchain.cmake" PARENT_SCOPE)
endfunction()

macro(_cpp_setup_build_env _csbe_name)
    #All tests associated with test will go in this directory
    set(test_prefix ${CMAKE_CURRENT_SOURCE_DIR}/${_csbe_name})

    #The particular run will go in a randomly generated sub-directory
    _cpp_make_random_dir(test_prefix ${test_prefix})
    message(
       "Tests from this run of ${_cbse_name} are located in ${test_prefix}"
    )

    #Make sure we don't contaminate the real cache or build directory
    _cpp_make_test_toolchain(${test_prefix})
    set(CMAKE_BINARY_DIR ${test_prefix})
    include(${CMAKE_TOOLCHAIN_FILE})
endmacro()

#Factor out the testing of the installed library
function(verify_dummy_install test_root)
    _cpp_assert_exists(${test_root}/include/dummy/a.hpp)
    _cpp_assert_exists(${test_root}/lib)
    foreach(share_file dummy-config.cmake dummy-config-version.cmake
            dummy-targets.cmake)
        _cpp_assert_exists(${test_root}/share/cmake/dummy/${share_file})
    endforeach()
endfunction()

function(verify_cpp_install test_root)
    foreach(share_file cpp-config.cmake cpp-config-version.cmake)
        _cpp_assert_exists(${test_root}/share/cmake/cpp/${share_file})
    endforeach()
endfunction()
