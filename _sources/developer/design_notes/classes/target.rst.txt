************
Target Class
************

Base class for an entire hierarchy of build and install classes. Basic API
is found `here <https://raw.githubusercontent.com/CMakePP/CMaize/master/
docs/src/developer/overall_design.png>`__.

Modern CMake is target-based, meaning for CMaize to be able to interact
with CMake effectively CMaize will need to be able to generate CMake
targets. The ``Target`` class provides an object-oriented API for 
interacting with a CMake target. It also serves as code factorization for
functionality/APIs common to all target types. Native CMake only has one
type of target, which can be annoying since the target is interacted with
in different ways depending on what it describes. The classes which derive
from Target provide a more user-friendly means of interacting with 
specific target types than native CMake does.

For more information on target properties, see `Properties on Targets
<https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html
#properties-on-targets>`__ in the `cmake-properties
<https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html>`__
section of the CMake documentation.
