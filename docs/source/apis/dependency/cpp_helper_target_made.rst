.. _cpp_helper_target_made-label:

cpp_helper_target_made
######################

.. function:: _cpp_helper_target_made(<return> <name>)

    Checks for the helper target that will exist if dependency was already found
    
     The helper target allows us to grab the FindRecipe object during
     ``cpp_install``. This function wraps the logic required to see if it exists
     so that other functions can remain decoupled from the target.
    
    :param return: An identifier to store the result of whether the target exists.
    