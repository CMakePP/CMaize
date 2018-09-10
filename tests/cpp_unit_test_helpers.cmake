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
