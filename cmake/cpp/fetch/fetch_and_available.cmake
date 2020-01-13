include_guard()
include(FetchContent)

#[[[ Fetches and makes a dependency available to the main project
#
# This function is code-factorization for the common scenario in which we want
# to declare a dependency (and how to obtain that dependency) and immediately
# make that dependency available to the project. This function is ultimately a
# thin wrapper around ``FetchContent_Declare`` and
# ``FetchContent_MakeAvailable``.
#
# :param _faa_name: The name of the dependency we are making available. This
#                   should be the dependency's official name as it would be used
#                   by other projects.
# :type _faa_name: desc
# :param *args: The additional arguments to forward to ``FetchContent_Declare``.
#]]
macro(cpp_fetch_and_available _faa_name)
    FetchContent_Declare("${_faa_name}" ${ARGN})
    FetchContent_MakeAvailable("${_faa_name}")
endmacro()
