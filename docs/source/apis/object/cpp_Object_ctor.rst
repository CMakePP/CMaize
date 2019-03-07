.. _cpp_Object_ctor-label:

cpp_Object_ctor
###############

.. function:: _cpp_Object_ctor(<handle>)

    Constructor for the Object base class common to all objects
    
     The Object class gives each object some bare bones intraspection members.
     These members include:
    
     * _cpp_member_list     - A list of all members added after the Object base class.
     * _cpp_member_fxn_list - List of all member functions
     * _cpp_type            - The class hierachy going from Object to most derived.
    
     :param result: The handle to the newly created object
    
    .. warning::
    
        This class is the base class of every class and can not use any of those
        classes in its ctor or else infinite recursion will occur. The result is
        that member functions of this class require special dispatch.
    