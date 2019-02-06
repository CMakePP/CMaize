.. _cpp_GetFromURL_ctor-label:

cpp_GetFromURL_ctor
###################

.. function:: _cpp_GetFromURL_ctor(<handle> <url> <kwargs>)

    Constructs an instance of the derived GetRecipe type GetFromURL
    
    The GetFromURL class is the base class for classes that obtain the source code
    from the internets. It extends GetRecipe by adding a member ``url`` which
    holds the URL for obtaining the source code.
    
    :param handle: An identifier to hold the handle to the returned object.
    :param url: The URL to download the source from
    :param kwargs: A kwargs instance with input options
    