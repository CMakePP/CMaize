include_guard()

## Function which builds a dependency from a user-provided build module.
#
# :param install: The path to the install root for the dependency.
# :param src: The path to the root of the source tree.
# :param tc: The path to the toolchain file to use for building.
# :param recipe: The path to the build module.
function(_cpp_user_build _cub_install _cub_src _cub_tc _cub_recipe)
    file(READ ${_cub_recipe} _cub_contents)
    _cpp_run_sub_build(
        ${_cub_src}
        NAME external_dependency
        INSTALL_DIR ${_cub_install}
        TOOLCHAIN   ${_cub_tc}
        CONTENTS    "${_cub_contents}"
    )
endfunction()
