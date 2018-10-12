.. _dependencies-label:

Registering Your Project's Dependencies with CPP
================================================

This page describes how to add dependencies to your project.  Let's start with
the harsh reality: CPP can only build a dependency if you provide it a means
of obtaining the source code.  Similarly, CPP can only find a dependency if
that dependency provides CMake packaging files or if a find recipe is
available.  As the C/C++ community writes better CMake-based build systems
(or better yet adopts CPP) we anticipate the need for writing find recipes to
drop considerably.  As for building a dependency we've striven to do it with
the absolute fewest amount of input possible.

Adding the Dependency
---------------------

There are two commands to add a dependency to your project
``cpp_find_dependency`` and ``cpp_find_or_build_dependency``.  The former is
simpler to use:

.. code-block:: cmake

   cpp_find_dependency(<name>)

This will look for the dependency with the provided name (CMake is unfortunately
case-sensitive so you'll have to get the case right; the community consensus is
that the name should be snake_case for whatever that's worth) if found the
targets from that package will be available for use as dependencies for your
targets.  If it's not found configuration will abort.

``cpp_find_or_build_dependency`` behaves similarly except that it will
build the dependency if it is not found.  Consequentially in addition to the
name of the dependency it requires information about where to find the source
code.  For the common case that the source is hosted on the internet:

.. code-block::cmake

   cpp_find_or_build_dependency(<name> URL <url>)

will suffice in many cases.  If instead you wish to bundle the dependency's
source code:

.. code-block::cmake

   cpp_find_or_build_dependency(<name> PATH <path>)

can be used.

For additional control you can set the version requirements of the dependency
using ``VERSION <version>`` and explicitly look for select components from the
package using ``COMPONENTS <comp1> <comp2> ...`` (well I plan to let you
anyways).

Advanced Customization
----------------------

We fully expect there to be some edge cases that don't fall within the bounds of
what we have above.  Typically we expect that these edge cases can be handled by
also specifying the

For full details regarding the APIs see: :ref:`cpp_find_dependency` and
:ref:`cpp_find_or_build_dependency`.
