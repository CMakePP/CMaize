include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("add_function")

_cpp_add_test(
TITLE "Error if name is empty"
SHOULD_FAIL REASON "Name shouldn't be empty"
"include(object/add_function)"
"include(object/ctor)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_add_function(\${handle} \"\" \"\")"
)

_cpp_add_test(
TITLE "Error if file dne"
SHOULD_FAIL REASON "${test_prefix}/${test_number}/a_fxn.cmake"
"include(object/add_function)"
"include(object/ctor)"
"_cpp_Object_ctor(handle)"
"_cpp_Object_add_function(\${handle} a_fxn \"\")"
)

_cpp_add_test(
TITLE "Works if file exists"
"include(object/add_function)"
"include(object/ctor)"
"file("
"   WRITE ${test_prefix}/${test_number}/a_fxn.cmake"
"   \"function(_cpp_Object_a_fxn)\nendfunction()\""
")"
"_cpp_Object_ctor(handle)"
"_cpp_Object_add_function(\${handle} a_fxn \"\")"
)

_cpp_add_test(
TITLE "Error if function already exists"
SHOULD_FAIL REASON "Function already exists"
"include(object/add_function)"
"include(object/ctor)"
"file("
"   WRITE ${test_prefix}/${test_number}/a_fxn.cmake"
"   \"function(_cpp_Object_a_fxn)\nendfunction()\""
")"
"_cpp_Object_ctor(handle)"
"_cpp_Object_add_function(\${handle} a_fxn \"\")"
"_cpp_Object_add_function(\${handle} a_fxn \"\")"
)
