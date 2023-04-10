# Compilers
set(CMAKE_C_COMPILER /usr/bin/gcc)
set(CMAKE_CXX_COMPILER /usr/bin/g++)

# Options
set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
set(BUILD_SHARED_LIBS TRUE)
set(BUILD_TESTING TRUE)
set(BUILD_DOCS FALSE)
set(CMAKE_CXX_STANDARD 17)

# Append dependency installations to the CMAKE_PREFIX_PATH so they
# can be found if they are installed
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}/install")

set(FETCHCONTENT_QUIET ON)
set(CMAKE_MESSAGE_LOG_LEVEL DEBUG)