.. _cpp_checks-label:

cpp_checks Module
=================

The ``cpp_checks`` module provides functions that facilitate determining if
various conditions have been met.  Developers of CPP are strongly encouraged to
use the checks within this module so as to avoid many of the plethora of
gotchas associated with CMake's if statements.


.. __cpp_is_defined-label:

_cpp_is_defined
---------------

.. function:: _cpp_is_defined(<return> <var>)

   Used to determine if an identifier is defined.  *N.B.* in CMake a identifier
   can be defined without having its value set, *e.g.*, ``set(A_VARIABLE)`` will
   define ``A_VARIABLE``, but not assign a value to it.

   :param return: The identifier to which the return should be assigned.
   :param var: The identifier to check.

.. __cpp_is_not_defined-label:

_cpp_is_not_defined
-------------------

.. function:: _cpp_is_not_defined(<return> <var>)

   Opposite of the ``_cpp_is_defined`` function.  Sets the identifier to true if
   the variable is not defined and false otherwise.

   :param return: The identifier to assign the return value to.
   :param var: The identifier to check.

.. __cpp_is_empty-label:

_cpp_is_empty
-------------

.. function:: _cpp_is_empty(<return> <var>)

   Used to determine if the value assigned to an identifier is the empty string.
   *N.B.* an undefined identifier will compare equal to the empty string.

   :param return: The identifier to which the return should be assigned.
   :param var: The identifier to check.

.. __cpp_non_empty-label:

_cpp_non_empty
--------------

.. function:: _cpp_non_empty(<return> <var>)

   Used to determine if the value of an identifier is anything besides the empty
   string.  *N.B.*, an undefined identifier compares equal to the empty string
   thus this function can be used to check if an identifier is valid (*i.e.*,
   defined and non-empty).

   :param return: The identifier to which the return should be assigned.
   :param var: The identifier to check for its empty-ness.

.. __cpp_contains-label:

_cpp_contains
-------------

.. function:: _cpp_contains(<return> <substring> <str>)

   A more convenient means of determining if a string contains a substring than
   CMake's default implementation.  Returns true if the substring is within the
   string and false otherwise.

   :param return: The identifier to save the return value to.
   :param substring: The value of the substring to look for.
   :param str: The value of the string to search

.. __cpp_does_not_contain-label:

_cpp_does_not_contain
---------------------

.. function:: _cpp_does_not_contain(<return> <substring> <str>)

   The opposite of the ``_cpp_contains`` function.  Returns true if the
   substring is not contained within the string.

   :param return: The identifier to save the return value to.
   :param substring: The value of the substring to look for.
   :param str: The value of the string to search.
