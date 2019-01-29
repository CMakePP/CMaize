include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("has_base")

_cpp_add_test(
TITLE "Object class"
"include(object/ctor)"
"include(object/has_base)"
"_cpp_Object_ctor(t)"
"_cpp_Object_has_base(\${t} test Object)"
"_cpp_assert_true(test)"
"_cpp_Object_has_base(\${t} test Derived)"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Derived class"
"include(object/object)"
"_cpp_Object_ctor(t)"
"_cpp_Object_set_type(\${t} Derived)"
"_cpp_Object_has_base(\${t} test Object)"
"_cpp_assert_true(test)"
"_cpp_Object_has_base(\${t} test Derived)"
"_cpp_assert_true(test)"
)
