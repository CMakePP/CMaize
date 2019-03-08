.. _design_points-label:

Design Points
=============

Summarily the design points/features of CMakePP are:

* Integrate into existing CMake workflows
* Ease of use
* Support for continuous integration
* Customizable settings, paths, behaviors
* Simplify dependencies
* Modernize CMake development

The following subsections describe these design points in more detail.

Workflow Integration
--------------------

Users have come to expect:

.. code-block:: bash

    cmake -B${build_dir} .
    cmake --build ${build_dir}
    cmake --build --target install

to build and install a CMake-based project. Admittedly the first line is rarely
that simple, but the sentiment remains. Any solution that extends CMake by
deviating from this pattern is likely to encounter resistance. To facilitate
this CMakePP is written as a CMake module. Simply load CMakePP into your
top-level ``CMakeLists.txt`` and you are good to go.


Ease of Use
-----------

For the most part building really boils down to specifying your project's:

* dependencies,
* sources,
* includes,
* libraries,
* executables,
* tests, and
* what needs installed.

CMakePP strives to make this as easy as possible by providing the package
maintainer APIs that require little more than lists of this information.

Continuous Integration
----------------------

Customizable
------------

The reality is build settings change from architecture to architecture and even
from use case to use case. CMakePP is designed so that the package maintainer
and the package's user can control every aspect of the build process. Final say
is given to the package's user since they are the one most familiar with the
system they are building for.

Dependencies
------------

Modernize
---------

