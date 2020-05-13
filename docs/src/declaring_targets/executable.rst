*************************
Declaring a C/C++ Library
*************************

.. code-block:: cmake

   cpp_add_library(
       chemist
       SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/src"
       INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/include"
       DEPENDS sde
   )
