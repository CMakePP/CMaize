.. Copyright 2023 CMakePP
..
.. Licensed under the Apache License, Version 2.0 (the "License");
.. you may not use this file except in compliance with the License.
.. You may obtain a copy of the License at
..
.. http://www.apache.org/licenses/LICENSE-2.0
..
.. Unless required by applicable law or agreed to in writing, software
.. distributed under the License is distributed on an "AS IS" BASIS,
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
.. See the License for the specific language governing permissions and
.. limitations under the License.

*********************
InstalledTarget Class
*********************

This class encompasses pre-built and pre-installed targets on the system.
Since they are already installed, CMaize does not need to build them, so 
the ``InstalledTarget`` class is essentially just a wrapper for the root
directory of the installation.

.. note::

   The root directory for the installation must exist at the time of
   instantiation.
