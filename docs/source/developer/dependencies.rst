.. dev_dependencies-label:

CPP's Dependency Strategy
=========================

The purpose of this page is to document the strategy for handling dependencies
with CPP.

Finding Dependencies
--------------------

From the perspective of CPP this is trivial.  Either the dependency is ideal and
provides a config file or there needs to be a find recipe available.  Either way
we're not responsible for that part.  What we're responsible for is the order in
which we look for the dependency.

Ultimately we want the end-user to be able to have the final say about which
installed version of a dependency is used.  Thus the first thing we do is check
if the user set ``${name}_ROOT``.  Note that ``${name}`` should evaluate to the
name of the dependency as ``find_package`` would look for it (*i.e.*, in
whatever case the name usually is in).  Anyways, if the user has set the
``${name}_ROOT`` variable we look for a config file under that path (and only
under that path).  If we can't find it we then punt and try to find it with a
find recipe.  Unfortunately, there's no way for us to limit the paths a find
recipe uses.  If we still can't find the dependency we abort as the user's
path was obviously bad.

If the user did not set ``${name}_ROOT`` then we look for the config file in the
list of paths given by the CMake (or environment) variables:

* CMAKE_PREFIX_PATH
* CMAKE_FRAMEWORK_PATH
* CMAKE_APPBUNDLE_PATH

if that returns nothing we check CPP's dependency cache.  If that's still a bust
we look in the usual places for that system, *i.e.*, the contents of:

* CMAKE_SYSTEM_PREFIX_PATH
* CMAKE_SYSTEM_FRAMEWORK_PATH
* CMAKE_SYSTEM_APPBUNDLE_PATH

If after all that we still can't find a config file we attempt to use a find
recipe to find the dependency (again we can't control the paths used within a
find recipe).  If that also fails, then we give up.

Building Dependencies
---------------------

