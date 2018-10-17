include(cpp_cmake_helpers)
include(cpp_checks)

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
    set(_cdcp_root ${_cdcp_prefix}/external/${_cdcp_NAME})
    _cpp_dummy_cxx_library(${_cdcp_root})
    _cpp_write_top_list(
        ${_cdcp_root}
        ${_cdcp_NAME}
        "include(cpp_targets)
         cpp_add_library(
            ${_cdcp_NAME}
            SOURCES ${_cdcp_root}/a.cpp
            INCLUDES ${_cdcp_root}/a.hpp
     )
     cpp_install(TARGETS ${_cdcp_NAME})
    "
    )
endfunction()

function(_cpp_install_dummy_cxx_package _cidcp_prefix)
    cmake_parse_arguments(_cidcp "" "NAME" "" ${ARGN})
    cpp_option(_cidcp_NAME dummy)
    set(_cidcp_root ${_cidcp_prefix}/external/${_cidcp_NAME})
    _cpp_dummy_cxx_package(${_cidcp_prefix} ${ARGN})
    _cpp_run_sub_build(
        ${_cidcp_prefix}
        INSTALL_PREFIX ${_cidcp_prefix}/install
        NAME build_${_cidcp_NAME}
        CONTENTS "include(cpp_build_recipes)
                  cpp_local_cmake(${_cidcp_NAME} ${_cidcp_root})"
    )

    #Sanity check
    set(_cidcp_path ${_cidcp_prefix}/install/share/cmake)
    _cpp_assert_exists(
        ${_cidcp_path}/${_cidcp_NAME}/${_cidcp_NAME}-config.cmake
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

    #Make sure we don't contaminate the real cache
    _cpp_make_test_toolchain(${test_prefix})
    include(${CMAKE_TOOLCHAIN_FILE})
endmacro()


function(_cpp_test_build_fails)
    set(_ctbf_O_KWARGS PATH NAME CONTENTS REASON)
    cmake_parse_arguments(_ctbf "" "${_ctbf_O_KWARGS}" "" ${ARGN})
    _cpp_run_cmake_command(
        COMMAND "set(CPP_DEBUG_MODE ON)
                 _cpp_run_sub_build(
                     ${_ctbf_PATH}
                     NO_INSTALL
                     NAME ${_ctbf_NAME}
                     CONTENTS \"${_ctbf_CONTENTS}\"
                 )"
        INCLUDES cpp_cmake_helpers
        RESULT _ctbf_result
        OUTPUT _ctbf_output

    )
    _cpp_debug_print("${_ctbf_output}")
    _cpp_assert_true(_ctbf_result)
    _cpp_assert_contains("${_ctbf_REASON}" "${_ctbf_output}")
endfunction()
