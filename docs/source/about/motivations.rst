.. _motivations-label:

Motivations
===========

This page details why we wrote CPP.  In particular we explain the overall
problem and why the other solutions didn't meet our needs.  If you don't care
why we wrote CPP the way we did we recommend jumping to the next page
:ref:`assumptions-label`.

After writing CMake-based build systems for a while an overall pattern becomes
apparent:

1. Find suitable dependencies
2. Build missing dependencies
3. Build project.
4. Test project.
5. Package project.

Strictly speaking one could argue that step 2 shouldn't be done by the build
system (it's really the job of a package manager); however, there's a bazillion
possible dependencies out there and expecting every possible package manager to
know about every possible package is unrealistic.  Furthermore asking the user
to build your project's dependencies decreases the user-friendliness (and thus
the adoption) of your project.  This is why we have chosen to include it.

Anyways of the above list, steps 1 and 2 are the hardest.  This is because
CMake's ``find_package`` and ``ExternalProject_Add`` commands are designed to be
quite general.  If the dependency you are trying to include implements an ideal
CMake-based build system, then these two functions will work without too much
hassle; unfortunately, a vanishingly small number of actual projects do this.
The result is your project's build system is typically tightly coupled to the
manner in which your dependencies were packaged.  Such coupling is problematic
when it occurs in source code, and unsurprisingly, leads to similar problems in
the build system.

Putting the above another way, if every project was packed ideally then those
projects would "just work" when included as dependencies and the remaining
three steps could be dramatically simplified. This is the idea behind CPP: to
build a dependency manager that works with ideally packaged projects, so that
build systems for new projects can be written quickly and confidently.  Of
course this still requires that that we somehow make existing, non-ideally
packaged dependencies appear as if they were ideally packaged.  Ultimately,
there's way around doing this on a per-package basis.  However, assuming a
community agreed upon standard for what constitutes "ideal" this only needs to
be done once in order for the entire community to benefit.

Additional Considerations
-------------------------

While not the primary motivation for writing CPP these were additional
considerations that were part of its design.

* Written in CMake
   CMake isn't the prettiest or easiest language to use, but it's the *de facto*
   standard for writing C/C++ build systems.  We choose to write CPP in CMake in
   order to avoid introducing additional dependencies into the project and to
   ensure that CPP integrates well with existing build systems.
* Capable of supporting virtual dependencies
   Virtual dependencies, dependencies focused more on an API than a particular
   library (*e.g.*, BLAS and MPI), need to be supported both at the API level as
   well as at the implementation level *e.g.*, need to be able specify that your
   project depends on BLAS or it depends on MKL (Intel's implementation of
   BLAS).
* Support for continuous integration workflows
   A lot of projects are moving to some version of continuous integration where
   concepts such as commit hashes and branches have more meaning than a numeric
   version.
* Project builder has final say in which implementation of a package is used
   Particularly on systems used for software development or for
   high-performance computing, the user may want to use a particular version of
   a dependency thus there needs to be a mechanism to ensure the dependency
   manager uses that version.
* Caching of dependencies
   During development it is common to "blow-away" the build directory to, for
   example, ensure one is not using stale assets.  99.9% of the time when one
   is doing this, they do not want the dependencies to be blown away.
* Decentralized management of build/find recipes
   Recipes for finding and building dependencies should not be restricted to a
   single location.  This allows each project to provide its own set of recipes,
   as well as allowing various communities and organizations to maintain their
   own set of recipes.  It also turns maintaining the recipes into a community
   endeavor instead of coupling it to CPP's development/maintenance.


Other Relevant Projects
-----------------------


In order to put CPP in perspective this section describes some other relevant
projects.

Hunter
^^^^^^

Hunter main page is available `here <https://github.com/ruslo/hunter>`_.

Before deciding to write CPP we initially tried Hunter.  Like CPP, Hunter is
written entirely in CMake and will locate and build dependencies for you
automatically.  Admittedly, Hunter was great at first and seemed to fit our
needs, but then a number of problems began to manifest (and in no small part
influenced the above additional considerations section):

* Documentation
   Hunter's documentation is lacking particularly when it comes to more advanced
   usage cases.  It's also hard to read.
* No support for virtual dependencies
   In all fairness, as of the time of writing, there were open issues on GitHub
   regarding this.
* Poor support for continuous integration
   Hunter assumed from the start that projects would depend on a particular
   version of a dependency.  With a lot of projects moving to a continuous
   integration model, "releases" are not always available.  Hunter's solution to
   the lack of releases is to use git submodules, but if you've ever tried using
   git submodules you know that they are never the solution...
* Difficult to control
   Hunter is a package manager and thus it assumes that it knows about all of
   the packages on your system. In turn if Hunter didn't build a dependency it
   won't use it (or at least I could not figure out how to override this
   behavior).
* Coupling of Hunter to the build recipes (``hunter/cmake/projects`` directory)
   The build recipes for dependencies are maintained by Hunter.  In order to
   make sure Hunter can build a dependency one needs to modify Hunter's
   source code. While having a centralized place for recipes benefits the
   community, having that place be Hunter's source makes Hunter appear
   unstable, clutters the GitHub issues, and places a lot of responsibility on
   the maintainers of the Hunter repo.
* Only supporting "official" recipes
   Admittedly this is related to the above problem, but Hunter will only use
   recipes that are stored in the centralized Hunter repo.  This makes it hard
   (again git submodules) to rely on private dependencies and hard to use Hunter
   until new dependencies are added to the repo.
