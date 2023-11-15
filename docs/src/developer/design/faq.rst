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

#################################
Frequently Asked Design Questions
#################################

This page contains questions pertaining to the design of CMaize, and their
answers.

.. _why_not_copy_paste:

**************************************************************
Why Shouldn't We Just Copy/Paste Build Systems Among Projects?
**************************************************************

Copy/paste-ing is a tried and true means of getting something working. Find
something close to what you want to do, copy/paste it, modify the copy to suit
your needs. The problem is copy/pasted code is a pain to maintain. The code is
coupled, but only implicitly. In other words, if the original source of the code
breaks and/or needs changed, the copies probably will too. If the common code
had been factored into a function, or similar reusable code unit, then changes
to the original would automatically propagate to the copies. Since copy/paste-ing
does not keep the original and the copies synchronized, the developer will need
to manually roll out changes to the copies as well. Unless records are
kept of where the copies live, it can be a pain to track down and modify all of
the copies. Even if records are kept, tracking down the copies can be tedious
and time consuming depending on the number and degree of changes needed.

.. _why_not_a_generator:

********************
Why not a generator?
********************

Generators work best when you only need to maintain the inputs to the
generator. Writing a build system is an exercise in edge cases. In turn, it is
highly unlikely that any generator will be able to cover every user's needs.
Thus, in general, users will need to modify the generated source code to address
their specific needs. Since a generator is essentially a tool which
copy/pastes source code (and then patches it), if the user then also modifies
the generated code, the user has essentially devolved to modifying copy/pasted
code (see :ref:`why_not_copy_paste` for why that's bad). Admittedly, the
generator makes the copy/paste-ing part easier. So, if the resulting source is
relatively stable, i.e., the content and structure does not change often, then
the user-specific modifications can be applied as a patch and automated. It is
our opinion that solutions which expect patching to be required are at best
incomplete solutions.
