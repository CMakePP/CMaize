.. _conventions:label:

Conventions
===========

These are the conventions to follow for contributing code to CPP.  Where
applicable the reasoning behind the conventions is provided.

Functions
---------

* The use of the ``macro`` command should be avoided in almost all scenarios

  * ``macro`` contaminates the parent namespace with the identifiers created in
     the macro.  This namespace is crowded enough already.

* Functions part of the public API should be namespace protected by prepending
  ```cpp``` to them
* Functions meant only for use within CPP should additionally be prepended 
  with a "_" character, *i.e.*, the full prefix is ``_cpp``    
* All function input names should be prefaced with ``_`` and the initials of the
  function (*e.g.*, the return value of ```cpp_is_defined``` is ``_cid_return``)

  * *N.B.*, when nesting functions, input variables with the same name clobber
    each other.  This is designed to avoid that.

* Variables defined within the function should follow the same convention as
  input variables
* If your function takes more than one input value, or some input values are
  optional use ``cmake_parse_arguments``.  This essentially imparts a syntax
  similar to Python's kwargs.

  * Easier to read as labels describe what the variable is used for.
  * Do not have to remember order of arguments.
  * Avoids the need for placeholder values.
* To the extent possible avoid using variables that are not part of the
functions signature

  * This makes the function's use more transparent and avoids the user needing
  to manipulate CMake variables to control your function.
  * An easy way to still use CMake variables for default values is:
  ``cpp_option(VARIABLE_USED_IN_FUNCTION CMAKE_VARIABLE_PROVIDING_DEFAULT)``
    

If Statements
-------------
Somewhat ironically, I find ``if`` statements to be one of the hardest parts of 
the CMake language.  The following conventions are designed to avoid as many 
gotchas as possible.

* When checking if the contents of a variable ``my_var`` is true do not 
  dereference it, *i.e.*, ``if(my_var)`` not ``if(${my_var})``

  * CMake will automatically try to dereference it for you
  * If ``my_var`` is empty the second syntax will lead to issues, whereas the
    first will evaluate to false

* Avoid the `NOT` keyword

  * The `NOT` syntax is touchy and error-prone owing to the implicit conversions
    between strings and booleans (a lot of times your boolean will become a 
    string and is then interpreted as ``NOT ${some_string}``)

* Use the helper functions in ``cpp_checks``

  * These functions return a value that can be used in an if statement
    without gotchas.
