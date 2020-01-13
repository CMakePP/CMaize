include_guard()
include(cpp/fetch/fetch_and_available)

function(cpp_fetch_cmake_module _fcm_name)
    set(BUILD_TESTS OFF)
    cpp_fetch_and_available("${_fcm_name}" ${ARGN})
    list(APPEND CMAKE_MODULE_PATH "${${_fcm_name}_SOURCE_DIR}/cmake")
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endfunction()
