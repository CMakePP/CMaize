include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("kwargs_unique")

_cpp_add_test(
TITLE "kwargs appears zero times"
"include(options/cpp_kwargs_unique)"
"set(kwarg_list KWARG1 KWARG2 KWARG3)"
"set(argn_list No kwargs here)"
"_cpp_kwargs_unique(\"\${kwarg_list}\" \"\${argn_list}\")"
)

_cpp_add_test(
TITLE "kwargs appear once each"
"include(options/cpp_kwargs_unique)"
"set(kwarg_list KWARG1 KWARG2 KWARG3)"
"set(argn_list KWARG1 KWARG2 value KWARG3 a list of stuff)"
"_cpp_kwargs_unique(\"\${kwarg_list}\" \"\${argn_list}\")"
)

_cpp_add_test(
TITLE "One kwarg appears twice"
SHOULD_FAIL REASON "The kwarg KWARG2 appears 2 times in the kwargs"
"include(options/cpp_kwargs_unique)"
"set(kwarg_list KWARG1 KWARG2 KWARG3)"
"set(argn_list KWARG1 KWARG2 value KWARG3 a list of stuff KWARG2)"
"_cpp_kwargs_unique(\"\${kwarg_list}\" \"\${argn_list}\")"
)
