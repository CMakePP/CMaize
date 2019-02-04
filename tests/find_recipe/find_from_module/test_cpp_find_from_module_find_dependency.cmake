include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_from_module_find_dependency")
_cpp_install_naive_cxx_package(install_dir ${test_prefix})
_cpp_naive_find_module(module ${test_prefix})

_cpp_add_test(
TITLE "Can not find dummy w/o path"
"include(find_recipe/find_from_module/find_from_module)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_FindFromModule_ctor(t ${module} \${kwargs} NAME dummy)"
"_cpp_FindFromModule_find_dependency(\${t} \"\" \"\" \"\")"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Can find dummy w path"
"include(find_recipe/find_from_module/find_from_module)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_FindFromModule_ctor(t ${module} \${kwargs} NAME dummy)"
"_cpp_FindFromModule_find_dependency(\${t} \"\" \"\" \"${install_dir}\")"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_true(test)"
)
