=======================================
APIs for Functions in cpp_checks Module
=======================================

The ``cpp_checks`` module provides functions that facilitate determining if
various conditions have been met.  Developers of CPP are strongly encouraged to
use the checks within this module so as to avoid many of the plethora of
gotchas associated with CMake's if statements.

.. function:: _cpp_is_defined(<return> <var>)

   Used to determine if an identifier is defined.  *N.B.* in CMake a identifier
   can be defined without having its value set, *e.g.*, ``set(A_VARIABLE)`` will
   define ``A_VARIABLE``, but not assign a value to it.

   :param return: The identifier to which the return should be assigned.
   :param var: The identifier to check.


.. function:: _cpp_is_empty(<return> <var>)

   Used to determine if the value assigned to an identifier is the empty string.
   *N.B.* an undefined identifier will compare equal to the empty string.

   :param return: The identifier to which the return should be assigned.
   :param var: The identifier to check.


.. function:: _cpp_non_empty(<return> <var>)

   Used to determine if the value of an identifier is anything besides the empty
   string.  *N.B.*, an undefined identifier compares equal to the empty string
   thus this function can be used to check if an identifier is valid (*i.e.*,
   defined and non-empty).

   :param return: The identifier to which the return should be assigned.
   :param var: The identifier to check for its empty-ness.
