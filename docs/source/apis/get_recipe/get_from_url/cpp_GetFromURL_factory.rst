.. _cpp_GetFromURL_factory-label:

cpp_GetFromURL_factory
######################

.. function:: _cpp_GetFromURL_factory(<handle> <url> <kwargs>)

    Dispatches among the various way to get source from the internet.
    
    This function is responsible for calling the correct ctor for the various
    classes derived from the ``GetFromURL`` class.
    
    
    :param handle: An identifier to hold the handle to the returned object.
    :param url: The URL to get the source from.
    :param kwargs: A Kwargs instance with inital values to forward to the ctors
    