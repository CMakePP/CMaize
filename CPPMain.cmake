macro(CPPMain)
    option(CPP_DEBUG_MODE "Enables extra debug printing" ON)
    option(
        CPP_LOCAL_PREFIX
        "Paths containing CPP caches"
        $ENV{HOME}/.cpp_cache
    )
    #These are options that you shouldn't need to touch
    option(
         CPP_INSTALL_PREFIX
         "Names of folders (relative to paths in CPP_LOCAL_PREFIX) for installs"
         install
    )
    option()
endmacro()
