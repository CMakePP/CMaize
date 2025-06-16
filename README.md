<!--
  ~ Copyright 2023 CMakePP
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
-->

![alt text](docs/src/assets/logo.png)

<!--
TODO: update DOI when it's known
[![Citation Badge](https://api.juleskreuer.eu/citation-badge.php?doi=10.1063/5.0147903)](https://juleskreuer.eu/projekte/citation-badge/)
-->

Documentation [link](https://cmakepp.github.io/CMaize)

We believe that the development of build systems should follow the same software
engineering best practices as traditional source code. One such best practice
is the DRY ("Don't Repeat Yourself") principle. Most build systems written in
CMake are extremely verbose and boilerplate heavy. CMaize was developed to 
facilitate writing CMake build systems which adhere to the DRY principle.

# Features

- Minimize boilerplate. CMake is verbose, CMaize isn't.
- Pure CMake. CMaize is written using the CMake programming language which means
  you have access to every feature CMake provides in addition to those provided
  by CMaize itself.
- Automatically keep up with CMake's ever changing best practices. CMaize 
  provides a stable API and maintains the mapping from that API to CMake's
  current best practices.
- Seamlessly integrate targets that rely on languages not supported by CMake.
  Currently limited to Python, but can be extended.

# Install

If you are using CMaize as part of your project's build system it is 
recommended that you set up your build system to automatically fetch CMaize. See
[here](https://cmakepp.github.io/CMaize/getting_started/using_cmaize_as_build_system/obtaining_cmaize.html)
for more details.

# Contributing

- [Contributor Guidelines](https://github.com/CMakePP/.github/blob/main/CONTRIBUTING.rst)
- [Contributor License Agreement](https://github.com/CMakePP/.github/blob/main/CONTRIBUTING.rst#contributor-license-agreement-cla)
- [Developer Documentation](https://cmakepp.github.io/CMaize/developer/index.html)
- [Code of Conduct](https://github.com/CMakePP/.github/blob/main/CODE_OF_CONDUCT.rst)

# Acknowledgments

This research was supported by the Exascale Computing Project (17-SC-20-SC), a 
collaborative effort of the U.S. Department of Energy Office of Science and the 
National Nuclear Security Administration. 

Additional funding has come for Iowa State University through the College of
Liberal Arts & Sciences Dean’s Professor Chair.
