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

Building the documentation
==========================

Assuming you have all of the documentation dependencies installed, building the
documentation is done by running:

```.bash
make html
```

in the this directory. If this runs successfully you will get an additional
directory `build`. The actual documentation can be viewed by opening
`${CMAKEPP_ROOT}/docs/build/html/index.html` in a web browser.

The documentation depends on:

- `sphinx` (the program which actually turns the reST into HTML)
- `sphinx_rtd_theme` (defines the HTML theme for the documentation)

These are all common packages which are readily available in most package
managers. To obtain them we recommend using Python's `pip` module in conjunction
with the `venv` module. This is done by running:

```.bash
python3 -m venv <name_of_virtual_environment>
source <name_of_virtual_environment>/bin/activate
pip install -r requirements.txt
```

in this directory.
