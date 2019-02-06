.. _cpp_Object_call_member-label:

cpp_Object_call_member
######################

.. function:: _cpp_Object_call_member(<handle> <fxn>)

    This function does not work, but starts a function for member dispatching.
    
    Basically the idea is to loop over the types of an object and assume that the
    class ``A`` implements a member function ``fxn`` in a file
    ``${a_root}/fxn.cmake`` where ``${a_root}`` is the directory containing the
    constructor (all ctors would need to be modified to record this). If the file
    exists we include it to bring the member into scope, if it doesn't exist we
    move on to the base class, repeating until we find the function or run out of
    base classes (raising an error in this case). Once we
    find the file we assume that all member functions have the same name and
    forward the arguments to it. We need to somehow figure out which inputs are
    returns so we can return them from this function too (kwargs??)
    
    
    