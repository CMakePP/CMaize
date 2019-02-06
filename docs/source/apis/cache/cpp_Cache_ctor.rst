.. _cpp_Cache_ctor-label:

cpp_Cache_ctor
##############

.. function:: _cpp_Cache_ctor(<handle> <path>)

    Provides an object-oriented view of the Cache
    
    Given a directory to use as a cache, this will create a Cache object from that
    directory. If the directory exists it will be used as is, otherwise that
    directory will be created.
    
    :Members:
    
      * root - The root directory of the Cache
    
    :param handle: An identifier to give the handle to.
    :param path: The directory to use as the Cache
    