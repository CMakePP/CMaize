include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("set_return")

_cpp_add_test(
TITLE "Works"
"include(utility/set_return)"
"function(test_fxn rv)"
"    _cpp_set_return(\${rv} \"hello world\")"
"endfunction()"
"test_fxn(test)"
"_cpp_assert_equal(\"\${test}\" \"hello world\")"
)
