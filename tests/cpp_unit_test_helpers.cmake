include(cpp_cmake_helpers)

function(_cpp_make_random_dir _cmrd_result _cmrd_prefix)
    string(RANDOM _cmrd_random_prefix)
    set(${_cmrd_result} ${_cmrd_prefix}/${_cmrd_random_prefix} PARENT_SCOPE)
    file(MAKE_DIRECTORY ${_cmrd_prefix}/${_cmrd_random_prefix})
endfunction()

function(_cpp_dummy_cmake_library _cdcl_prefix)
    set(_cdcl_inc  ${_cdcl_prefix}/a.hpp)
    set(_cdcl_src  ${_cdcl_prefix}/a.cpp)
    file(WRITE ${_cdcl_inc} "int a_fxn();\n")
    file(WRITE ${_cdcl_src} "int a_fxn(){return 0;}\n")
    _cpp_write_top_list(${_cdcl_prefix}/CMakeLists.txt A
"include(cpp_targets)
cpp_add_library(A SOURCES ${_cdcl_src} INCLUDES ${_cdcl_inc})
"
    )
endfunction()

function(_cpp_make_test_toolchain _cmtt_prefix)
    file(READ ${CMAKE_TOOLCHAIN_FILE} _cmtt_file)
    string(REGEX REPLACE "\n" ";" _cmtt_file "${_cmtt_file}")
    set(_cmtt_new_file)
    foreach(_cmtt_line ${_cmtt_file})
        string(FIND "${_cmtt_line}" "set(CPP_LOCAL_CACHE"  _cmtt_is_cache)
        if("${_cmtt_is_cache}" STREQUAL "-1")
            list(APPEND _cmtt_new_file "${_cmtt_line}")
        else()
            list(
                APPEND
                _cmtt_new_file
                "set(CPP_LOCAL_CACHE \"${_cmtt_prefix}/cpp_cache\")")
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
endmacro()
