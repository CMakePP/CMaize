.. _cpp_Kwargs_ctor-label:

cpp_Kwargs_ctor
###############

.. function:: _cpp_Kwargs_ctor(<_cKpa_handle>)

    Class for holding the user-provided kwargs
    
    :members:
    
       * toggles  - List of keywords that take no arguments
       * options  - List of keywords taking one argument
       * lists    - List of keywords taking one or more arguments
       * unparsed - The contents of ``ARGN`` that were not parsed
    
    .. warning::
    
        The Function class uses the Kwargs class in its ctor unless the
        ``NO_KWARGS`` flag is provided to the Function ctor. Hence, in order for
        the Kwargs class to register its member functions, each member function
        can not take kwargs.
    