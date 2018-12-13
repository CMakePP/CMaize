.. _cpp_find_or_build_dependency-label:

cpp_find_or_build_dependency
############################

.. function:: cpp_find_or_build_dependency()

    
    This function is the public API for users who want CPP to build a dependency
    if it can not be found.
    
    :kwargs:
    
        * *NAME* (``option``) - The name of the dependency we are looking for.
        * *URL* (``option``) - The URL to use to download the dependency.
        * *BRANCH* (``option``) - The branch of the source code to use, if the
          source code is version controlled with git.
        * *PRIVATE* (``toggle``) - If present, specifies that the URL points to
          a private GitHub repository. The repository will be accessed using the
          value of ``CPP_GITHUB_TOKEN``.
        * *SOURCE_DIR* (``option``) - Provides the path to the source code for the
          dependency.
        * *VERSION* (``option``) - The version of the dependency we are looking
          for.
        * *COMPONENTS* (``list``) - A list of components that the dependency must
          provide.
        * *FIND_MODULE* (``option``) - The path to a user provided find module.
        * *TOOLCHAIN* (``option``) - The path to the toolchain file to use. By
          default the current toolchain is used.
        * *CPP_CACHE* (``option``) - The path to the CPP cache to use. By default
          the current CPP cache is used.
        * *BINARY_DIR* (``option``) - The directory to use as a build directory
          for the dependency. Defaults to the current build directory.
    
    :CMake Variables:
    
        * *CPP_INSTALL_CACHE* - Used as the default CPP cache. Behavior can be
          overridden by the ``CPP_CACHE`` kwarg.
        * *CMAKE_TOOLCHAIN_FILE* - Used as the default toolchain. Behavior can be
          overriden by the ``TOOLCHAIN`` kwarg.
        * *CMAKE_BINARY_DIR* - Used as the default build directory. Behavior can
          be overridden by the ``BINARY_DIR`` kwarg.
        * *CPP_GITHUB_TOKEN* - Used to retrieve the user's token if GitHub
          authentication is needed.
    