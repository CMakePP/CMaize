include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("call_function")

set(class1_root ${test_prefix}/class1)

file(WRITE ${class1_root}/ctor.cmake
"include(object/object)
function(_cpp_Class1_ctor _cCc_handle)
    _cpp_Object_ctor(_cCc_temp)
    _cpp_Object_set_type(\${_cCc_temp} Class1)
    _cpp_Object_add_function(\${_cCc_temp} a_fxn return)
endfunction()"
)

file(WRITE ${class1_root}/a_fxn.cmake
"include(object/object)
function(_member_fxn _cCc_handle arg1)
    set(return \${arg1} PARENT_SCOPE)
endfunction()"
)

file(WRITE ${test_prefix}/class2/ctor.cmake
"include(object/object)
include(${test_prefix}/class1/ctor.cmake)
function(_cpp_Class2_ctor _cCc_handle)
    _cpp_Class1_ctor(_cCc_temp)
    _cpp_Object_set_type(\${_cCc_temp} Class2)
    _cpp_Object_add_function(\${_cCc_temp} a_fxn return)
endfunction()"
)

file(WRITE ${test_prefix}/class2/a_fxn.cmake
"include(object/object)
function(_member_fxn _cCc_handle arg1)
    set(return \"\${arg1}+class2\" PARENT_SCOPE)
endfunction()"
)

_cpp_add_test(
TITLE "Fails if object does not have function"
SHOULD_FAIL REASON "Class does not have a member function a_fxn"
"include(object/ctor)"
"include(object/add_function)"
"include(object/call_function)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_call_function(\${handle} prefix a_fxn arg1)"
)

_cpp_add_test(
TITLE "Call void(void)"
"include(object/call_function)"
"include(${class1_root}/ctor.cmake)"
"_cpp_Class1_ctor(handle)"
"_cpp_Object_call_function(\${handle} prefix a_fxn arg1)"
"_cpp_assert_equal(\"\${prefix_return}\" \"arg1\")"
)
