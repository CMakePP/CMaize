include_guard()

## Function which generates the build-recipe for a dependency.
#
# The build-recipe configures, builds, and installs the dependency. This
# function generates the callback to be used as the build-recipe. Ultimately,
# this has two parts: providing the appropriate build-recipe API and fixing the
# arguments to :ref:`cpp_build_recipe_dispatch`.
#
# :param output: The identifier used to hold the returned recipe.
# :param args: The list of additional CMake Arguments to provide the sub-build.
#     If no additional arguments are needed pass the empty string.
# :param module: If the user provided a build module this is the full path to
#     that module, otherwise it's the empty string.
function(_cpp_generate_build_recipe _cgbr_output _cgbr_args _cgbr_module)
    set(
        ${_cgbr_output}
"function(_cpp_build_recipe _cbr_install _cbr_src _cbr_tc)
    include(recipes/cpp_build_recipe_dispatch)
    _cpp_build_recipe_dispatch(
        \"\${_cbr_install}\"
        \"\${_cbr_src}\"
        \"\${_cbr_tc}\"
        \"${_cgbr_args}\"
        \"${_cgbr_module}\"
    )
endfunction()"
        PARENT_SCOPE
    )
endfunction()
