.. _lists-label:

Forwarding Lists
================

The reality is users can provide CPP with lists as input.  It is CPP's job to
respect those lists and make sure they get forwarded correctly.  This page will
explain in agonizing detail why this is so much more of a pain than it sounds.

The Problem
-----------

A typical scenario is that the user has things installed in multiple places and
needs to provide multiple paths to the ``CMAKE_PREFIX_PATH`` variable.  At the
command line they do:

.. code-block:: bash

   cmake -DCMAKE_PREFIX_PATH="path1;path2;path3"

and within CMake ``CMAKE_PREFIX_PATH`` is now set to a three item list.
Basically when CMake encounters a semicolon in a string it treats it as a list
separator and swallows it.  The problem comes in when we have lists of lists.
For example assume we have the following call to ``_cpp_write_list``
(irrelevant details are elided):

.. code-block:: cmake

   _cpp_write_list(
      ...
      CONTENTS "set(list1 \"one;two;three\")"
               "set(list2 \"four;five;size\")"
   )

where the escapes, ``\``, are to ensure that CMake treats the quotes as literal
characters and not as denoting the beginning/end of a string.  While hard coding
a list in this manner is unnatural, it arises quite naturally from variable
expansion, for example:

.. code-block:: cmake

   _cpp_write_list(
      ...
      CONTENTS "set(CMAKE_PREFIX_PATH \"${CMAKE_PREFIX_PATH}\")"
               "set(CMAKE_MODULE_PATH \"${CMAKE_MODULE_PATH}\")"
   )

Anyways, internally what happens is everything going into ``_cpp_write_list``
gets concatenated into the variable ``ARGN``.  Printing ``ARGN`` for our simple
hard-coded example yields (only the relevant part is shown):

.. code-block:: cmake

   set(list1 "one;two;three");set(list2 "four;five;six")

See the problem?  To CMake this is a single list with six elements:

   set(list1 "one
   two
   three)
   set(list2 "four
   five
   six)

The problem is CMake can't tell the two lists apart.

The Solution
------------

The technically correct solution is hinted at by how we passed the nested
quotes, namely we need to escape the semicolons in the lists.  While being the
solution advocated for by CMake, it's very annoying, owing to it being somewhat
hard to know ahead of time when you need an escape and how many.  The result is
that using escape characters becomes a bit of a trial and error process, which
is undesirable.  Our solution is to use a delimiter that will not interfere with
CMake.  When defining our delimiter we need to be careful to not exchanges one
delimiter problem for another.  In particular we define the CPP list delimiter:
``_cpp_X_cpp_`` with ``X`` denoting the number of nestings (starting from 0).
This allows us to hide the semicolons from CMake, while keeping track of
nestings.
