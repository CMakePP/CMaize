.. _FAQs-and-Common-Build-Problems:

******************************
FAQs and Common Build Problems
******************************

For private repos CPP_GITHUB_TOKEN must be a valid token
========================================================

Cause
^^^^^

CMaize is trying to clone a private GitHub repository and you have not provided
CMaize with a valid GitHub authentication token.

Solution
^^^^^^^^

Assuming you have permission to read the repository and have generated a GitHub
authentication token (see `creating a personal access token <https://help.github
.com/articles/creating-a-personal-access-token-for-the-command-line/>`_ for
information on doing so) make
sure you have set the value of ``CPP_GITHUB_TOKEN`` to the value of the token.
