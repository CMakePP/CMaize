.. _cpp_GetFromGithub_ctor-label:

cpp_GetFromGithub_ctor
######################

.. function:: _cpp_GetFromGithub_ctor(<handle> <url> <kwargs>)

    Constructs an instance of the derived GetRecipe type GetFromGithub
    
    :param handle: An identifier whose value will be the newly created object.
    :param url: The GitHub URL to download the source from
    :param kwargs: A Kwargs object containing the user-supplied options
    
    :kwargs:
    
      * *BRANCH* - The git branch to use.
      * *NAME*   - The name of the dependency
      * *VERSION* - The version of the dependency to get.
      * *PRIVATE* - Whether or not this is a private GitHub repo
    