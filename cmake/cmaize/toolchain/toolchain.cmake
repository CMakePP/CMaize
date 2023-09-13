# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard()
include(cmakepp_lang/cmakepp_lang)

#[[[
# Variables that CMaize will autopopulate in its ``Toolchain`` object.
# This variable is a list of strings representing variable names.
#]]
set(_CMAIZE_TOOLCHAIN_AUTOPOPULATED_VARIABLE_NAMES "")
list(APPEND _CMAIZE_TOOLCHAIN_AUTOPOPULATED_VARIABLE_NAMES "CMAKE_C_COMPILER")
list(APPEND _CMAIZE_TOOLCHAIN_AUTOPOPULATED_VARIABLE_NAMES "CMAKE_CXX_COMPILER")

#[[[
# The ``Toolchain`` class is a source code representation of the toolchain
# file that can be provided by users to specify options sent to every
# dependency.
# 
# Users need a way to specify options which should be passed to every 
# dependency. By convention this is done by setting the options in a 
# toolchain file. The Toolchain class is the source code representation of 
# this file, containing values autopopulated by CMaize, as well as
# user-specified options. User options take precidence over autopopulated
# values.
#]]
cpp_class(Toolchain)
    
    ## Map of options automatically populated
    cpp_attr(Toolchain auto_options)

    ## Contents of the user-provided toolchain file. These take higher
    ## priority than those automatically populated by CMaize. This should
    ## be treated as immutable once the values are read into it.
    cpp_attr(Toolchain encoded_toolchain_contents)

    #[[[
    # Default constructor for Toolchain object with only autopopulated
    # options available.
    #
    # :param self: Toolchain object constructed.
    # :type self: Toolchain
    # :returns: ``self`` will be set to the newly constructed ``Toolchain``
    #           object.
    # :rtype: Toolchain
    #]]
    cpp_constructor(CTOR Toolchain)
    function("${CTOR}" self)

        # Initialize the toolchain object
        Toolchain(__initialize "${self}")

        # Store toolchain contents
        Toolchain(SET "${self}" encoded_toolchain_contents "")

    endfunction()

    #[[[
    # Constructor for Toolchain object with a path to a toolchain file.
    #
    # :param self: Toolchain object constructed.
    # :type self: Toolchain
    # :param toolchain_path: Path to the toolchain file to load.
    # :type toolchain_path: path
    # :returns: ``self`` will be set to the newly constructed ``Toolchain``
    #           object.
    # :rtype: Toolchain
    #]]
    cpp_constructor(CTOR Toolchain path)
    function("${CTOR}" self toolchain_path)

        cpp_file_exists(toolchain_exists "${toolchain_path}")
        if(NOT "${toolchain_exists}")
            string(CONCAT exception_msg
                "Provided toolchain file does not exist. Toolchain provided: "
                "${toolchain_path}"
            )
            cpp_raise(FileNotFound "${exception_msg}")
        endif()

        # Initialize the toolchain object
        Toolchain(__initialize "${self}")

        # Read the toolchain file
        file(READ "${toolchain_path}" file_contents)

        # Store toolchain contents
        cpp_encode_special_chars("${file_contents}" encoded_file_contents)
        Toolchain(SET "${self}"
            encoded_toolchain_contents "${encoded_file_contents}"
        )

    endfunction()

    #[[[
    # Constructor for Toolchain object with a string assumed to be the
    # contents of an already opened toolchain file.
    #
    # :param self: Toolchain object constructed.
    # :type self: Toolchain
    # :param file_contents: Contents of the toolchain file.
    # :type file_contents: str
    # :returns: ``self`` will be set to the newly constructed ``Toolchain``
    #           object.
    # :rtype: Toolchain
    #]]
    cpp_constructor(CTOR Toolchain str)
    function("${CTOR}" self file_contents)

        # Initialize the toolchain object
        Toolchain(__initialize "${self}")

        # Store toolchain contents
        cpp_encode_special_chars("${file_contents}" encoded_file_contents)
        Toolchain(SET "${self}"
            encoded_toolchain_contents "${encoded_file_contents}"
        )

    endfunction()

    #[[[ Generate the contents of a toolchain file.
    #
    # Generates a string with valid toolchain file contents based on the
    # state of the toolchain object. The generated contents will contain
    # the autopopulated options first, followed by the user-specified
    # toolchain file, verbatim. By putting the user-specified toolchain
    # file after the autopopulated options, the user-specified options
    # will override any autopopulated options.
    #
    # If you need to write the toolchain contents to a file, use the
    # ``write_file`` member function instead of ``generate_file_contents``.
    # 
    # :param self: Toolchain object to generate toolchain file from.
    # :type self: Toolchain
    # :param return_value: Return value with toolchain file contents.
    # :type return_value: str
    # :returns: Toolchain file content string.
    # :rtype: str
    #]]
    cpp_member(generate_file_contents Toolchain str)
    function("${generate_file_contents}" self return_value)

        # Initialize the file contents with a warning
        string(CONCAT file_string
            "# This file was generated by CMaize. Any changes made to this\n"
            "# file will be overwritten the next time it is generated.\n\n"
        )

        # Get the autopopulated options
        Toolchain(GET "${self}" auto_opt_map auto_options)
        cpp_map(KEYS "${auto_opt_map}" keys)

        # Start the autopopulated section
        string(APPEND file_string "# CMaize Autopopulated Options\n\n")

        # Add the autopopulated options
        foreach(key ${keys})
            cpp_map(GET "${auto_opt_map}" value "${key}")
            string(APPEND file_string "set(${key} ${value})\n")
        endforeach()

        # Start the user toolchain section
        string(APPEND file_string "\n# User Toolchain\n\n")

        # Add the user toolchain
        Toolchain(GET "${self}" file_contents encoded_toolchain_contents)
        string(APPEND file_string "${file_contents}")

        cpp_decode_special_chars("${file_string}" "${return_value}")

        cpp_return("${return_value}")

    endfunction()

    #[[[ Writes the toolchain object contents to a toolchain file.
    #
    # If the contents of this toolchain file are needed, they can be
    # generated directly with the ``generate_file_contents`` member
    # function.
    #
    # :param self: Toolchain object to create toolchain file from.
    # :type self: Toolchain
    # :param toolchain_path: Location to write toolchain file. This should
    #                        include the toolchain file name as well.
    # :type toolchain_path: path
    #]]
    cpp_member(write_toolchain Toolchain path)
    function("${write_toolchain}" self toolchain_path)

        # Generate the toolchain contents
        Toolchain(generate_file_contents "${self}" file_contents)

        # Write the contents to the specified file
        file(WRITE "${toolchain_path}" "${file_contents}")

    endfunction()

    #[[[
    # Autopopulates certain toolchain variables as default values to be used
    # if not specified by the user toolchain file.
    #
    # :param self: Toolchain object to autopopulate.
    # :type self: Toolchain
    #]]
    cpp_member(_autopopulate_options Toolchain)
    function("${_autopopulate_options}" self)

        # Get the autopopulated map
        Toolchain(GET "${self}" auto_opt_map auto_options)

        # Autopopulate some values from the CMake environment
        foreach(var_name ${_CMAIZE_TOOLCHAIN_AUTOPOPULATED_VARIABLE_NAMES})
            cpp_map(SET "${auto_opt_map}" "${var_name}" "${${var_name}}")
        endforeach()

    endfunction()

    #[[[
    # Initialize empty option maps of the Toolchain object and autopopulates
    # some options.
    #
    # :param self: Toolchain object to initialize.
    # :type self: Toolchain
    #]]
    cpp_member(__initialize Toolchain)
    function("${__initialize}" self)

        # Set the auto-populated map to an empty map
        cpp_map(CTOR auto_opt_map)
        Toolchain(SET "${self}" auto_options "${auto_opt_map}")

        # Autopopulate some options
        Toolchain(_autopopulate_options "${self}")

    endfunction()

cpp_end_class()
