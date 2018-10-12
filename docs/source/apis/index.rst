.. _apis-label:

APIs
####

Contents:
---------

.. toctree::
   :maxdepth: 2

   cpp_assert
   cpp_build_recipes
   cpp_checks
   cpp_cmake_helpers
   cpp_dependency
   cpp_main
   cpp_options
   cpp_print
   cpp_targets
   cpp_toolchain

While reading through the APIs note that we use a few terms with very precise
meanings:

identifier
   A variable name.  Given an identifier ``my_identifier`` it should be possible
   to do ``${my_identifier}``.

value
   The result of dereferencing an identifier, *i.e.*, the result of
   ``${my_identifier}``.

list
   A specific type of value with multiple parts.  For most purposes it suffices
   to know that ``set(my_identifier value1 value2 value3)`` makes the value of
   ``my_identifier`` to be a list of three values and that list is forwarded to
   a function by ``a_fxn("${my_identifier}")``.  The double quotes are required
   or else only the first element is forwarded.
