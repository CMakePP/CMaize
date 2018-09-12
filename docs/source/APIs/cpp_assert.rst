=================
cpp_assert Module
=================

The ``cpp_assert`` module provides functions that facilitate asserting that a
critical condition is met and if that condition is not met, aborting the run.
Functions from this module play a critical role in unit testing of CPP as well
as ensuring that input logic is not invalidated.  Like the ``cpp_checks`` module
this module helps avoid common CMake gotchas and functions within this module
should be preferred over raw if statements while developing CPP.

.. function:: _cpp_assert_true(<var>)

   Aborts the program if the value held by the identifier is not true.  *N.B.*
   the input to this function is the identifier to check **NOT** the value of
   the identifier.  This is because this function is commonly used to check the
   "return" of a function before proceeding.

   :param var: The identifier whose value will be compared for true-ness.

.. function:: _cpp_assert_false(<var>)

   Same as ``_cpp_assert_true`` except checks that the value held by the
   identifier is false.  Aborts the program if the held value is true.

   :param var: The identifier whose value will be considered for false-ness.

.. function:: _cpp_assert_equal(<lhs> <rhs>)

   Compares two values and aborts the run if the two values are not equal.
   *N.B.* the inputs to this function are the actual values **NOT** the
   identifiers holding the values.  This is because a very common use case is
   to hard-code the value one is comparing against.

   :param lhs: The value "on the left" of the equality comparison
   :param rhs: The value "on the right" of the equality comparison

.. function:: _cpp_assert_not_equal(<lhs> <rhs>)

   Same as ``_cpp_assert_equal``, except it checks that the two values are not
   equal and aborts the run if they are equal.

   :param lhs: The value "on the left" of the inequality comparison
   :param rhs: The value "on the right" of the inequality comparison.


.. function:: _cpp_assert_exists(<path>)

   Checks to ensure that the provided path points to an existing file or
   directory.  The assertion does not care whether the path points to a file or
   a directory.  If the path does not exist the run is aborted.

   :param path: The path to check for existence.
