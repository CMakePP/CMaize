include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_options)
include(cpp_assert)

#Sets a non-set option
cpp_option(UNSET_OPTION TRUE)
_cpp_assert_true(UNSET_OPTION)

#Empty string counts as not set
set(EMPTY_OPTION "")
cpp_option(EMPTY_OPTION TRUE)
_cpp_assert_true(EMPTY_OPTION)

#Ensure it doesn't overwrite an already set option
set(SET_OPTION FALSE)
cpp_option(SET_OPTION TRUE)
_cpp_assert_false(SET_OPTION)
