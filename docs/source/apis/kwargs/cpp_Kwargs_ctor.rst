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
    