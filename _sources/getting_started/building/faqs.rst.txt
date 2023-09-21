..
   Copyright 2023 CMakePP

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

.. _faqs_and_common_build_problems:

##############################
FAQs and Common Build Problems
##############################

For private repos CMAIZE_GITHUB_TOKEN must be a valid token
===========================================================

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
