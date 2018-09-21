======================================
APIs for Functions in cpp_print Module
======================================

The ``cpp_print`` module provides functions for printing/logging messages.

.. function:: _cpp_debug_print(<msg>)

   Prints additional information while CMake is running if CPP is in debug
   mode.  Information printed by this function is designed to facilitate the
   debugging of an unsuccessful ``cmake`` invocation (or to present the user
   with very detailed information related to the configuration).  CPP's debug
   mode is set by setting ``CPP_DEBUG_MODE`` to a truthy value.  *N.B.* debug
   printing is denoted to the user by pre-pending "CPP DEBUG:" to the message.

   :param msg: The string to print if CPP is in debug mode.

   CMake variables used:

   * CPP_DEBUG_MODE

.. function:: _cpp_print_target(<name>)

   This function prints out the properties associated with a target.  Note that
   this target must be non-interface.  For printing interface targets see
   `_cpp_print_target`.

   :param name: The name of the target we want to print.

.. function:: _cpp_print_interface(<name>)

   This function is the same as `_cpp_print_target` except it knows to only try
   to print properties that are whitelisted for an interface target.
   Unfortunately, I can not figure out any way to know *a priori* if a target is
   an interface target so we have to have separate functions.

   :param name: The name of the interface target to print the properties of.
