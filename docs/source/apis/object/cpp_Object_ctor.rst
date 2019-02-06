.. _cpp_Object_ctor-label:

cpp_Object_ctor
###############

.. function:: _cpp_Object_ctor(<handle>)

    Constructor for the Object base class common to all objects
    
     The Object class gives each object some bare bones intraspection members.
     These members include:
    
     * _cpp_member_list - A list of all members added after the Object base class.
     * _cpp_type        - The class hierachy going from Object to most derived.
    
     :param result: The handle to the newly created object
     :param type: The type to create
    