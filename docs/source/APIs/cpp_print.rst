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
