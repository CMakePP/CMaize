include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("serialize")

set(corr "{ \\\"_CPP_TYPE\\\" : \\\"T\\\" , ")
set(corr "${corr}\\\"_CPP_MEMBERS\\\" : [ \\\"member1\\\" ] , ")
set(corr "${corr}\\\"member1\\\" : \\\"NULL\\\" }")

_cpp_add_test(
TITLE "Basic Object"
"include(object/object)"
"_cpp_Object_constructor(handle T member1)"
"_cpp_Object_serialize(test \${handle})"
"_cpp_assert_equal(\"${corr}\" \"\${test}\")"
)
