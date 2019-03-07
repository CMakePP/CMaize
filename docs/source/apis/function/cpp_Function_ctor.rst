.. _cpp_Function_ctor-label:

cpp_Function_ctor
#################

.. function:: _cpp_Function_ctor(<handle> <file>)

    Class responsible for implementing a function
    
     The Function class is a generic functor that is intended primarily to be used
     as a member function of an object. The class stores a list of kwargs that the
     function recognizes and a list of identifiers that will be used for returning
     variables (at the time of the actual run the caller provides a prefix that
     will be prepended to each of these variables to avoid name collisions). The
     class also attempts to take care of some of the error-checking for your
     function. For example, it will check that all options are set to a value.
    
    :param handle: An identifier to hold the newly created object.
    :param file: The file that holds the definition of the function
    
    :Members:
    
       * *returns*  - List of identifiers that will be returned by the function.
       * *kwargs*   - Kwargs object
       * *this*     - The handle of the object this function belongs to
    :kwargs:
        * *NO_KWARGS* - A toggle that signals the function takes no kwarg-based
                        input.
        * *THIS*      - The handle of the object this function belongs to
        * *TOGGLES*   - A list of input parameters to the function that should be
                        treated as toggles.
        * *OPTIONS*   - A list of inputs that should take a single value.
        * *LISTS*     - A list of inputs that should take 0 or more values.
        * *RETURNS*   - A list of identifiers that will be used for returns
    