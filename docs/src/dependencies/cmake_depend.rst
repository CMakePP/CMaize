****************************
Dependencies Which Use CMake
****************************

.. code-block:: cmake

   include(cpp/cpp)

   cpp_find_or_build_dependency(
       sde
       URL github.com/NWChemEx-Project/sde
       PRIVATE TRUE
       BUILD_TARGET sde
   )
