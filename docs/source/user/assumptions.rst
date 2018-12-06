.. _assumptions-label:

Assumptions Made by CPP
=======================

CMake is a very broad language that attempts to cover and support many edge
cases.  It is also the reason CMake is so complicated.  In order for CPP to work
we have to make some assumptions about your project.  Those assumptions are
described on this page as well as the rationale behind them.  If you are writing
a build system based on CPP or converting to a CPP based variant make sure these
assumptions all hold.

1. You have only one project
----------------------------

What this means is that CPP will only be responsible for managing the
dependencies of a single CMake project (*i.e.*, your project should contain
only one call to the CMake ``project`` command).  CMake itself does not support
nested calls to this command.  To work around this, either split your project
into several subprojects (each managed by CPP) or choose one project to be the
main project and add the other projects as components.

2. Variables with the prefix "CPP" are reserved
-----------------------------------------------

CMake's variables are visible to all nested calls.  This means there needs to
be some namespacing in effect to prevent clobbering.  CMake reserves variables
that start with "CMAKE" (and some that don't) for itself and "CPP" reserves
variables that start with "CPP" for itself.  That said, it's okay to change
variables if you are directly interacting with CPP, *e.g.*, it's okay to set
``CPP_DEBUG_MODE`` to on to tell CPP that you want additional debug printing,
but it is not okay to declare a variable ``CPP_DIRECTORY`` to refer to the
directory where you installed CPP.  As a corollary to this assumption we
also assume you are familiar with all of the available CMake variables and do
not attempt to appropriate them for your own use.

3. Variables prefixed with "_" are reserved
-------------------------------------------

Same idea as the second point, except variables starting with "_" are
conventionally used inside CMake and CPP functions.  CPP applies a namespace
protection to all variables used inside functions, so a collision is unlikely,
but nonetheless it's best not to tempt fate.


4. Your CMakeLists are Responsibly Written
------------------------------------------

If there's one assumption you're likely to violate it's this one.  Generally
speaking your project should not be setting any CMake variable as part of your
build system.  Variables like ``CMAKE_CXX_FLAGS`` and the like are for use by
the person building your project.  99.9% of the time when you are setting these
variables you should really be setting the property of a target.
