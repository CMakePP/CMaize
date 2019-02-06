################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()

## Creates the C++ source and header file for a simple test library
#
# This function will create a header file ``XXX.hpp`` which declares a single
# function ``int XXX_fxn()`` and a source file ``XXX.cpp``, which defines the
# function (it just makes it return 2).
#
# :param prefix: The path to use as as a source directory.
#
# :kwargs:
#
#     * *NAME* (``option``) - The value of ``XXX`` in, for example, ``XXX.hpp``.
#       Defaults to "a".
#
# .. note::
#
#     This function does **NOT** create the ``CMakeLists.txt`` file required to
#     build the resulting library.
#
function(_cpp_dummy_cxx_library _cdcl_prefix)
    #Parse kwargs
    cmake_parse_arguments(_cdcl "" "NAME" "" "${ARGN}")
    if("${_cdcl_NAME}" STREQUAL "")
        set(_cdcl_NAME a)
    endif()

    #Signature of the function, factored out
    set(_cdcl_fxn_sig "int ${_cdcl_NAME}_fxn()")

    #Write the header file
    set(_cdcl_header_contents "${_cdcl_fxn_sig};")
    set(_cdcl_header_file ${_cdcl_prefix}/${_cdcl_NAME}.hpp)
    file(WRITE ${_cdcl_header_file} "${_cdcl_header_contents}\n")

    #Write the source file
    set(_cdcl_src_file ${_cdcl_prefix}/${_cdcl_NAME}.cpp)
    set(_cdcl_fxn_def "${_cdcl_fxn_sig}{return 2;}")
    set(_cdcl_src_inc "#include \"${_cdcl_NAME}.hpp\"")
    set(_cdcl_src_contents "${_cdcl_src_inc}\n${_cdcl_fxn_def}")
    file(WRITE ${_cdcl_src_file} "${_cdcl_src_contents}\n")
endfunction()
