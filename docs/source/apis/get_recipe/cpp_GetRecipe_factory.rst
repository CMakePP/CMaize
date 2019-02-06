.. _cpp_GetRecipe_factory-label:

cpp_GetRecipe_factory
#####################

.. function:: _cpp_GetRecipe_factory(<handle> <kwargs>)

    Function for encapsulating the logic surrounding how to get a dependency
    
    This top-level factory is responsible for dispatching based on the mechanism
    for obtaining the source code. For example if ``URL`` is specified this
    factory will dispatch to the ``GetFromURL`` factory.
    
    :kwargs:
    
      * *URL*        - Where on the internets the source is located.
      * *SOURCE_DIR* - A local directory containing the source code.
    