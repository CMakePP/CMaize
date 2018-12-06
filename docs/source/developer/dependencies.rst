.. dev_dependencies-label:

CPP's Dependency Strategy
=========================

The purpose of this page is to document the strategy for internally handling
dependencies with CPP.  While describing our dependency process we will use the
following conventions when referring to a dependency ``Name``.  ``Name``,
``NAME``, and ``name`` are the names of the dependency respectively in the
initial case, all uppercase, and all lowercase. Keep in mind that CMake is case
sensitive so the case used to specify the dependency is important.  We also will
assume that the dependency is distributed as source files (thus it needs to be
configured, built, and installed); if this is not the case CPP can still be used
to manage the dependency by skipping the irrelevant steps.

Overview
--------

Generally speaking the dependency process can be broken down into:

1) Attempt to locate a suitable, already built, version.  If found done.
2) Obtain dependency's source code.
3) Configure dependency's source code.
4) Build dependency
5) Install dependency
6) Repeat step 1) aborting if dependency is still not found.

Note step 6, this is important because in CMake it's the act of finding the
package that brings the targets into scope. Generally speaking it is steps 1 and
3 that have the most variation. Step 2 usually amounts to downloading a tarball
from the internet, or using a local source tree. Step 4 and Step 5 have no
variation (from our perspective) and amount to running:

.. code-block:: bash

   cmake --build <build_dir>

and

.. code-block:: bash

   cmake --build <build_dir> --target install

respectively.

To deal with the variation in steps 1 through 3 we will use "recipes".  Recipes
are nothing more than CMake scripts that we use as callbacks. Basically, each
recipe defines a function, adhering to a standardized API, whose contents
implement the package specific steps for obtaining, configuring, and/or building
the dependency.  CPP recognizes three types of recipes:

* find recipes
    Used in steps 1 and 6 to locate and bring into scope an installed package

* get recipes
    Used in step 2 to obtain a tarball of the dependency's source code

* build recipes
    Used in step 3 to configure the dependency's source code in preparation for
    building.

The user is always free to write their own recipe for a particular dependency,
but generally speaking CPP will autogenerate the required recipe from minimal
user input.  In fact our end goal is to get to a point where
``cpp_find_or_build_dependency(NAME <Name> VERSION <version>)`` is a valid line.

Before discussing our strategy in more detail it is worth noting a few points:

* Many projects are moving to CI development cycles. In such cycles, the numeric
  version is often not sufficient for distinguishing the state of the source
  code (particularly when using git, most projects do not update tags for every
  commit).  We will use hashes of the source code to instead makes such
  distinctions.

* In a similar vein, we will use hashes of the toolchain to distinguish between
  configurations.  Based on the way CPP is designed, the only ways to get a
  different configuration are to modify the source code or to modify the
  toolchain.  The former will affect the source's hash and the latter the
  configuration's hash.

* We have no way of knowing what cmake variables affect a dependency.  The
  result is likely to be a lot of cache misses for deeply nested projects.  The
  reason is that the toolchain keeps picking up options as CPP recurses, hence
  the hash changes.

* There's a lot of coupling between pieces of this algorithm.  For example, if
  we decide that find_recipes go to the path ``/root/find_recipes`` then every
  part of this algorithm needs to check this path.  While this may seem trivial,
  realize that there's a bunch of cache paths, and they're needed all over the
  place. Furthermore it's hard to keep track of whether a file should exist
  already or not.

* It's relatively easy to make a dependency when it doesn't exist. It's much
  harder to find that dependency on subsequent calls. Our solution is to use
  memoization.  Namely, regardless of whether we are looking for a dependency
  for the first time (specifically before we build it) or the hundredth time our
  control flow travels through the same routines.

Detailed Internal Strategy
--------------------------

The last section hit on the highlights of what we're dealing with, this section
will spell out our strategy in agonizing detail. Starting from the top, the
entire algorithm for finding and building dependencies is encapsulated within
the ``cpp_find_or_build_dependency`` function. This is one of two public APIs to
our dependency framework. The other public API is ``cpp_find_dependency``,
which only performs step 1 (and 6 since it's just step 1 again).

When ``cpp_find_or_build_dependency`` is called the first thing that CPP does,
even before it calls ``cpp_find_dependency``, is to write the get-, find-, and
build-recipes to the cache.  This ensures that these recipes are available
for the remainder of the algorithm since they will be needed to get paths
(recall the paths contain hashes to distinguish between versions and
configurations so we need the literal assets to compute the paths). The
registering of the dependency with the cache is accomplished by calling
``_cpp_cache_add_dependency``.

``_cpp_cache_add_dependency`` is responsible for parsing all of the information
the user gave us and turning it into suitable recipes. For each type of recipe
we call a function ``_cpp_XXX_recipe_dispatch``, where ``XXX`` is one of the
recognized recipe types. These functions analyze the user's input to put
together the final recipe. As the names imply, the recipe dispatchers are
responsible dispatching to proper backend for that recipe, *e.g.*, if the user
provides a GitHub URL, the ``_cpp_get_recipe_dispatch`` function is responsible
for writing a get recipe that knows how to retrieve the contents from GitHub.
Thus these dispatch routines are the place to add new automations.  Once the
recipe is determined, it is added to the cache via the
``_cpp_cache_add_XXX_recipe`` function, which encapsulates the details
pertaining to exactly where the recipe goes.

As a slight aside, examining the various recipes shows that they often just call
another function. While it is tempting to do without the recipes and rely on
another dispatch mechanism.  The problem with this approach is that it doesn't
leave us with any sort of record regarding how a dependency was obtained, which
version was obtained, or how it was built.  This in turn means that when we try
to subsequently recompute the paths we no longer have all of the required input.
In particular, note that we need this input to survive over multiple runs.  In
theory, it may be possible to harness CMake's cache to accomplish this
persistent state; however, this makes it harder to dynamically change how a
dependency is obtained/built/or found because now all of that information is
stored in one localized place, ``CMakeCache.txt``, instead of decoupled files.
Finally, I'm just not comfortable with manipulating ``CMakeCache.txt``.

Next we record the ``cpp_find_or_build_dependency`` command to a target
``_cpp_<Name>_External``. This will eventually allow us to print the same
``cpp_find_or_build_dependency`` command in the ``config-<name>.cmake`` file so
that memoization can occur on subsequent attempts to find the dependency. We use
a target so that it is globally visible without the user having to provide a
variable to store it in. It may be possible to get away with just injecting a
variable into the namespace from which ``cpp_find_or_build_dependency`` was
called, but such a solution would break if ``cpp_install`` wasn't called in
the same namespace (or a directory under it).  Thus the use of a target avoids
unnecessary restrictions on the user.

After recording the command we assemble the toolchain to use for building the
dependency (if it comes to that). Since the toolchain determines the
configuration of the dependency we need to assemble it before attempting to find
the dependency (*i.e.* the hash of the toolchain is part of the install path).

With the recipes and toolchain in hand we now have all of the information
needed to compute the install path that CPP would have used if CPP has
already built the dependency. Hence we call ``cpp_find_dependency`` providing
the install path as a hint. Inside ``cpp_find_dependency`` the first step is to
call ``_cpp_record_find`` to record the find command. This will be a null op if
the ``_cpp_<Name>_External`` target already exists and is necessary in case the
user directly called ``cpp_find_dependency``. After recording we attempt to find
the dependency by honoring ``<Name>_ROOT`` or ``<Name>_DIR``.  These attempts
are encapsulated by ``_cpp_special_find`` (which ultimately calls
``_cpp_find_package`` with the variable contents as a hint).
``_cpp_special_find`` also tries some other variations on capitalization in the
attempt to be more user-friendly.

Regardless of whether it's the call inside ``_cpp_special_find`` or the call
inside ``cpp_find_dependency`` the actual attempt at locating the dependency is
encapsulated by ``_cpp_find_package``. ``_cpp_find_package`` is a wrapper
over CMake's ``find_package`` that standardizes the API a bit more.  Namely, it
insists on creating a target to hold the dependency's paths and options.  This
target is only created if the dependency itself does not create one. This target
will be populated assuming the dependency follows the older CMake practices of
setting variables like ``<Name>_INCLUDE_DIRS`` and ``<Name>_LIBRARIES``. If made
by CPP, the target will be named ``<Name>``.

If after the call to ``cpp_find_dependency`` the dependency is still not found
CPP will build it using the recipes. This amounts to calling the get-recipe to
obtain a tarball of the source.  Untarring the tarball. Configuring the
resulting source. Building the configured source and then installing the source.
After the dependency is built ``cpp_find_dependency`` is called again and an
error is raised if the dependency still can't be found.

In list form our call tree looks like:

1. ``_cpp_cache_add_dependency``

   a. Parse information for obtaining the dependency
   b. Add get-recipe to cache
   c. Parse information for finding the dependency
   d. Add find-recipe to cache
   e. Parse information for building the dependency
   f. Add build-recipe to cache

2. ``_cpp_record_find``
3. Write toolchain file
4. ``cpp_find_dependency``

   a. ``_cpp_record_find``
   b. ``_cpp_special_find``
   c. ``_cpp_find_package``

      i. Call find-recipe
      ii. If find-recipe did not make a target, make one

5. If not found, ``_cpp_cache_build_dependency``

   a. Use get-recipe to obtain the source
   b. Use build-recipe to build source


6. ``cpp_find_dependency``, failing if not found


Find-Recipes
------------

Find-recipes are the easiest of the three recipes because there's only two ways
to find a package: config files or module files. CPP dispatches among these
mechanisms based on whether or not ``FIND_MODULE`` is set in the call to
``cpp_find_or_build_dependency``. If found, CPP will copy the find-module into
the cache and hard-code the path into the find-recipe. If not found, the
resulting find-recipe will assume config files are present. Thanks to CMake's
native support for find modules, we do not anticipate any scenario under which a
user will have to manually write a find-recipe.

Regardless of the body of the find-recipe it must define a macro/function with
the signature:

.. code-block::cmake

   _cpp_find_recipe(<version> <comps> <path>)

where the arguments respectively are the minimum version of a dependency to look
for, the components of the dependency that must be present, and a hint for where
to look (typically the path to be used for installing). Macros are allowed to
facilitate forwarding of CMake's ``find_package``'s results. Regardless of
whether the body calls CMake's ``find_package`` or not, the find-recipe is
responsible for setting ``<Name>_FOUND``, which is what CPP will use to
determine if the package was found or not. For find-recipes autogenerated by CPP
we rely on ``find_package`` to set this variable, which in turn is automatic for
searches that rely on config files and must be done somewhat manually for
modules by calling ``FindPackageHandleStandardArgs``.

Get-Recipes
-----------

Obtaining the source for a dependency typically is done by downloading it from
the internet.  Thanks to sites like GitHub, it's even possible to do so while
using version control. There's of course other ways to obtain source code, such
as local version control servers or the age-old practice of bundling it with
your package. It should be possible to extend CPP so that it can automate any
procedure for procuring source code; however, we do forsee that there are
scenarios under which a user may want to write their own get-recipe (such as a
quick workaround for an unsupported procurement system).

Like the find-recipe, the body of the get-recipe contains the actual details
pertaining to where the source comes from and how we get it. CPP only requires
that the API for the get-recipe adhere to:

.. code-block::cmake

   _cpp_get_recipe(<output> <version>)

where ``output`` is the full path to where the get recipe should place the
tarballed source (the path will include the resulting file name) and version is
used to control which version of a dependency should be retrieved. It is the
get-recipe's responsibility to dispatch on the version.

Build-Recipes
-------------

Of the three types of recipes these are the ones we anticipate having the most
variability. This is because we need to support numerous build system generators
(and build systems). Furthermore, dependencies do not always utilize build
system generators in ideal fashions and workarounds are necessary. CPP strives
to automatically map CMake variables and options to the dependency's native
meta-build system/build system, but this may not always be feasible. For this
reason, it is expected that users will have to write their own build-recipes
for very non-standard projects.

The build-recipe API is:

.. code-block::cmake

   _cpp_build_recipe(<install> <src> <toolchain> <args>)

Where ``install`` is the full path to the root of the install tree (*e.g.*, it
would point to ``/usr/local`` on a typical Unix-like system). ``src`` is the
full path to source that the recipe is supposed to build. ``toolchain`` is the
toolchain file to use for building the dependency and ``args`` is a list of
key value pairs (in the form ``<key>=<value>``) supplied to the ``CMAKE_ARGS``
kwarg of ``cpp_find_or_build_dependency`` (the args will have already been added
to the toolchain, but are kept separate to facilitate discerning what the
end-user set (the toolchain contents) and what the user set.


Notes on ExternalProject_Add
----------------------------

Users familiar with CMake's ``ExternalProject_Add`` command will note that it
works via a set of similar steps.  There's two major disadvantages to the
``ExternalProject_Add``  command: it runs during the build phase (making it hard
to properly treat dependencies without utilizing a superbuild) and it doesn't
know anything about the CPP framework.  The result is that we need to manually
implement each of the steps of ``ExternalProject_Add`` so that they use CPP's
framework and occur at configure time.
