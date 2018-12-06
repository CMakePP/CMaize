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

CMake Parse Arguments
---------------------

As mentioned above this works similar to Python's kwargs, and since CMake
apparently doesn't have a word for this concept I'm just going to call them
kwargs.  Here's some tips/conventions for using kwargs in CMake:

* There's three types of kwargs: toggles, one value, multiple value.

  * Toggles take zero values and are either present (ON) or not present (OFF)
  * One value kwargs take a single value
  * Multiple value kwargs take one or more values.

* By convention recognized keywords are stored in variables.  One for each
  type of kwarg.  The names of these variables are also given by convention
  (``<prefix>`` is the function's variableprefix):

  * toggles are listed in ``<prefix>_T_kwargs``,
  * one value kwargs are listed in ``<prefix>_O_kwargs``, and
  * multiple value kwargs are listed in ``<prefix>_M_kwargs``

* Check required kwargs with :ref:`cpp_assert_true-label`.
* Avoid crashing if an unrecognized keyword is present

  * Useful for compatibility with other CPP versions with different keywords
  * Facilitates forwarding kwargs to subfunctions when subfunction takes
    different keywords.

* Be careful with keywords accepting multiple values, they can pickup kwargs
  meant for forwarding.

  * If your function has a kwarg that accepts multiple values you need to look
    for all kwargs that your subfunctions will use.


Kwargs work best if functions accepting them use the same keywords for the same
concepts.  In particular, this convention avoids intermediate functions
from having to this case you can pass
all the
arguments to the
next function simply by passing
``${ARGN}``.  To that end we have established the following conventions for
naming keywords.  I've tried to keep them consistent with CMake's corresponding
variables.

* TOOLCHAIN
   Used to store the path to the toolchain that a function should use.
* CPP_CACHE
   Used to store the path to the current CPP Cache.
* SOURCE_DIR
   Used to store the path to the root of a file hierarchy.
* INSTALL_DIR
   Used to store the path where something should be installed.
* CMAKE_ARGS
   Used to store additional variables that should be set when calling a sub
   CMake command.
* BINARY_DIR
   Used to store the path to a directory for holding build files.
* VERSION
   Stores the version of a target
* COMPONENTS
   Stores a list of subtargets.
* NAME
   Stores the name of a dependency (often different than the actual target name)
* TARGETS
   Stores a list of targets (typically different than the package name)

File Structure
--------------

Since CPP is purely written in CMake we follow the convention of placing all
source files in a folder titled ``cmake``. This will eventually be installed to
a path ``${CMAKE_INSTALL_PREFIX}/share/cmake/cpp`` so that for example
``cmake/CPPMain.cmake`` will live at
``${CMAKE_INSTALL_PREFIX}/share/cmake/cpp``. Within the ``cmake`` folder, source
files are separated into modules.
