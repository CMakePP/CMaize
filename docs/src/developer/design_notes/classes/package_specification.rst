**************************
PackageSpecification Class
**************************

The ``PackageSpecification`` class is envisioned as holding all of the
details about how to build a package ("package" being a catchall for a
dependency or the package that the CMaize build system is being written
for). This includes things like where the source code lives, the version
to build, and specific options for configuring and compiling.
``PackageSpecification`` instances will ultimately be used to request
packages from the ``PackageManager`` and inform ``CMaizeTarget`` classes.

Usage
=====

Creating a PackageSpecification
-------------------------------

One constructor is provided to create an instance of ``PackageSpecification``,
which will contain some default values determined for your system, with:

.. code-block:: cmake

   # Create PackageSpecification object
   PackageSpecification(ps_obj)

Modifying a PackageSpecification
--------------------------------

After a default instance is created, most attributes should be accessed and
modified using CMakePPLang object `getters and setters
<https://cmakepp.github.io/CMakePPLang/features/classes.html
#getting-and-setting-attributes>`__. However, to ensure that all version
component variables are set correctly, you should use the
``PackageSpecification(set_version`` method to set a package version.

At the moment, the ``configure_options`` and ``compile_options`` attributes
are not populated by ``PackageSpecification``. These maps are available for
classes using ``PackageSpecification`` to populate with relevant information.
