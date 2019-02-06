include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("kwargs_ctor")

_cpp_add_test(
TITLE "Basic Usage"
"include(kwargs/ctor)"
"_cpp_Kwargs_ctor(handle)"
"foreach(member_i toggles options lists unparsed)"
"   _cpp_Object_has_member(\${handle} test \${member_i})"
"   _cpp_assert_true(test)"
"endforeach()"
)

