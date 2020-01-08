include_guard()
include(FetchContent)

function(cpp_fetch_cmake_module _fcm_name)
    include(FetchContent)
    FetchContent_Declare(
        "${_fcm_name}"
        ${ARGN}
    )
    set(BUILD_TESTS OFF)
    FetchContent_MakeAvailable("${_fcm_name}")
    list(APPEND CMAKE_MODULE_PATH "${${_fcm_name}_SOURCE_DIR}")
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endfunction()
