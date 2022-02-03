****************************
Declaring a C/C++ Executable
****************************

.. code-block:: cmake

   cpp_add_executable(
       chemist
       SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/src"
       DEPENDS sde
   )
