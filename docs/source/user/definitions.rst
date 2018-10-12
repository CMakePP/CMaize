.. _definitions-label:

Definitions
===========

For the user's convenience we have assembled the definitions of the various
terms used throughout the documentation.

* Package Manager
    A program used to add, remove, and select the packages installed on a
    system.  On an ideal system all packages are installed by the package
    manager and all packages preferentially use the packages provided by the
    package manager for satisfying their dependencies.
* Dependency Manager
    Unlike a package manager, a dependency manager is responsible only for
    managing packages on a per-project basis.  This management includes
    project-specific settings like compilation options and patches.  Like a
    project manager, a dependency manager typically also knows how to find and
    build packages this in turn provides a point of contention between package
    managers and dependency managers.
