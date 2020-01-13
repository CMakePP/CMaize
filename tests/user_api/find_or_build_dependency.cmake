include(cmake_test/cmake_test)

ct_add_test("cpp_find_or_build_dependency")
    include(cpp/user_api/find_or_build_dependency)

    cpp_find_or_build_dependency(Catch2 URL https://github.com/catchorg/Catch2)
ct_end_test()
