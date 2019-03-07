.. _cpp_url_parser-label:

cpp_url_parser
##############

.. function:: _cpp_url_parser(<org> <repo> <url>)

    Parses the organization and repository out of a GitHub/GitLab URL
    
    This function will take a GitHub/GitLab URL of the form 
    ``gitxxx.com/org/repo`` and parse out the organization and repository. The 
    actual parsing is insensitive to whether or not generic prefixes like ``www.``
    and ``https://`` are present. The function will raise errors if an 
    organization or a repository is not present.
    
    :param org: The identifier to store the organization's name under.
    :param repo: The identifier to store the repository's name under.
    :param url: The URL that we are parsing.
    