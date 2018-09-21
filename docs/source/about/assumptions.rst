.. _assumptions-label:

Assumptions Made by CPP
=======================

CMake is a very broad language that attempts to cover and support many edge
cases.  It is also the reason CMake is so complicated.  In order for CPP to work
we have to make some assumptions about your project.  Those assumptions are
described on this page as well as the rationale behind them.

1. You Only Have One Project
----------------------------

What this means is that CPP will only be responsible for managing the
dependencies of a single CMake project.  This project can have multiple
components, but at the end of the day statements like "build my project" and
"install my project" have to make sense.  This is also a fundamental limitation
of CMake itself (you can't nest ``project`` commands).  The thought is that if
you have two projects they should be treated as two separate projects, each with
their own CMake infrastructure.  The biggest consequence of this assumption is
that there can only be one call to ``cpp_install`` per project as multiple
calls would clobber the config files (or would be identical and thus redundant).

2. Variables with the Prefix "CPP" are Reserved
-----------------------------------------------

Simple enough.  This is the same idea as reserving variables that start with
"CMAKE" for CMake.  It's basically a namespacing policy.  It means that the user
of CPP should not declare or manipulate any variable prefixed with "CPP" unless
they are directly interacting with CPP, *e.g.*, it's okay to set
``CPP_DEBUG_MODE`` to on to tell CPP that you want additional debug printing,
but it is not ok to declare a variable ``CPP_DIRECTORY`` to refer to the
directory where you installed CPP as CPP may presently or in the future use that
variable with a different meaning.  Failure to heed this assumption will likely
cause errors that are very hard to debug.  As a corollary to this assumption we
also assume you are familiar with all of the available CMake variables and do
not attempt to appropriate them for your own use.


3. Your CMakeLists are Responsibly Written
------------------------------------------

Generally speaking your project should not be setting the values of variables
like ``CMAKE_CXX_FLAGS`` and the like.  If you need to compile a specific target
with specific options you should be setting those options directly for the
target (``target_compile_options`` for compiler flags and
``target_compile_definitions`` for symbols to define).  Variables like
``CMAKE_CXX_FLAGS`` are for the end user (the person trying to compile your
project) not for your project.

4. Your Project is Structured Well
----------------------------------

CPP tries to be quite flexible with respect to how you can structure your
project's directory structure; however, we do not provide for an infinite
amount of flexibility.
