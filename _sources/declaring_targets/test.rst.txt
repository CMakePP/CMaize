**********************
Declaring a C/C++ Test
**********************

.. code-block:: cmake

   cpp_add_test(
       test_chemist
       SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/tests"
       DEPENDS Catch2 chemist
   )
