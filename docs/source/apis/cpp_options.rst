==================
cpp_options Module
==================

The ``cpp_options`` module is primarily meant to provide functions for
manipulating build options; however, it is also used internally within CPP for
providing an identifier a default value.

.. function:: cpp_option(<var> <default_value>)

   This function will make the identifier contain the default value unless the
   identifier is already set.  *e.g.*, ``cpp_option(my_identifier a_value)``
   will set ``my_identifier`` to ``a_value`` unless ``my_identifier`` is already
   set.

   :param var:  The identifier to set (if it's not set already)
   :param default_value: The value to set the identifier to (if it's not set
       already)

   CMake variables used:

   * CPP_DEBUG_PRINT for controlling debug printing
