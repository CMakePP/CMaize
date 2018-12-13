.. _cpp_parse_gh_url-label:

cpp_parse_gh_url
################

.. function:: _cpp_parse_gh_url(<org> <repo> <url>)

    Function which parses the organization and repository out of a GitHub URL
    
    This function will take a GitHub URL of the form ``github.com/org/repo`` and
    parse out the organization and repository. The actual parsing is insensitive
    to whether or not generic prefixes like ``www.`` and ``https://`` are present.
    The function will raise errors if an organization or a repository is not
    present.
    
    :param org: The identifier to store the organization's name under.
    :param repo: The identifier to store the repository's name under.
    :param url: The URL that we are parsing.
    