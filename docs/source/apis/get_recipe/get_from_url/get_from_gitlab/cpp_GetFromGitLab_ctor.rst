.. _cpp_GetFromGitLab_ctor-label:

cpp_GetFromGitLab_ctor
######################

.. function:: _cpp_GetFromGitLab_ctor(<handle> <url> <kwargs>)

    Constructs an instance of the derived GetRecipe type GetFromGitLab
    
    :param handle: An identifier whose value will be the newly created object.
    :param url: The GitLab URL to download the source from
    :param kwargs: A Kwargs object containing the user-supplied options
    
    :kwargs:
      * *VERSION* - The release to get
      * *BRANCH*  - The branch or commit to get
    