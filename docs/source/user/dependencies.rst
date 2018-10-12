.. _dependencies-label:

Registering Your Project's Dependencies with CPP
================================================

This page describes how to add dependencies to your project.  Let's start with
the harsh reality: CPP can only build a dependency if you provide it a means
of obtaining the source code.  Similarly, CPP can only find a dependency if
that dependency provides CMake packaging files or if a find recipe is
available.  As the C/C++ community writes better CMake-based build systems
(or better yet adopts CPP) we anticipate the need for writing find recipes to
drop considerably.

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

Regardless of which variant you use it is possible to be more specific regarding
the details of the dependency, *e.g.*, you can request a specific minimum
version or that certain components be present.  For full details regarding the
APIs see: :ref:`cpp_find_dependency` and :ref:`cpp_find_or_build_dependency`.


Finding the Dependency
----------------------

If the dependency follows the correct CMake procedures for packaging itself then
you don't need to consider this section.  If it does not, and it uses CMake
consider filing a bug report for that project (it really is a bug).  If the
project will not fix their build or they don't use CMake then read on.



Advanced Customization
----------------------

Rewrite to say: call the appropriate cpp_build_recipe function directly.

The functions and conventions above are designed to meet typical dependency
needs.  Inevitably there will be corner-cases that require special attention.
For fine-tuning or debugging the build procedure it is possible for your
project to include a custom build recipe when calling
``cpp_find_or_build_dependency``.  Depending on how that custom build recipe
differs from the more general one consider adding your modifications to the
general recipe (*e.g.*, if you need a certain component built that the original
recipe did not support, that's worth contributing; if you need the dependency
built with the source patched that should not be contributed).

Modifying the find procedure can be done in a similar manner if the dependency
is found by find recipes.  If it is found by locating CMake packaging files
then either of the find calls provided by CPP will be inappropriate.  The most
straightforward way to do this is to use ``find_package(<name> MODULE)`` with
``CMAKE_MODULE_PATH`` set to the path to your find recipe.  Make sure you
change ``CMAKE_MODULE_PATH`` back afterwards.  Note, that if you have to take
this course of action it probably signals a bug in the generation of the CMake
files; so consider filing a bug-report.

Note it is unreasonable to expect the version of a dependency built by a
dependency manager to reach peak-performance on a given architecture.  It's
reasonable to assume that users of your package realize that too, and if they
care about peak-performance they will build all dependencies themselves.  That
said, if your performance depends critically on how a dependency is built
consider either forcing the user to build it or always building it yourself
(*i.e.*, call ``_cpp_build_dependency`` directly).
