*****************
BuildTarget Class
*****************

This class serves as an abstract base class for language-specific target
classes of supported languages that CMaize can build.

``BuildTarget`` includes the basic information needed to build a target,
including the paths and files needed to compile or import, project
specifications, and lists of dependencies that need to be built, along with
those that are already installed on the system. Additionally, it includes
general build functions that need to be overridden in children.
