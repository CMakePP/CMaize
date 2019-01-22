include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("negate")


foreach(true_value 1 ON YES TRUE Y 19)
    _cpp_add_test(
        TITLE "Makes true value ${true_value} false"
        "include(logic/negate)"
        "_cpp_negate(test ${true_value})"
        "_cpp_assert_false(test)"
    )
endforeach()

foreach(false_value O OFF NO FALSE N IGNORE NOTFOUND "" xxx-NOTFOUND)
    _cpp_add_test(
        TITLE "Makes false value \"${false_value}\" true"
        "include(logic/negate)"
        "_cpp_negate(test \"${false_value}\")"
        "_cpp_assert_true(test)"
    )
endforeach()
