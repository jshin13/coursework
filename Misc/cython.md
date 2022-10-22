## Cython Notes

### Releasing GIL
***The GIL is a lock held by the python interpreter process whenever bytecode is being executed unless it is explicitly released. I.e. the design of the cpython interpreter is to assume that whatever that occurs in the cpython process between bytecodes is dangerous and not thread-safe unless told otherwise by the programmer. This means that the lock is enabled by default and that it is periodically released as opposed to the paradigm often seen in many multi-threaded programs where locks are generally not held except when specifically required in so-called "critical sections" (parts of code which are not thread-safe).***

***And when it comes to managing the GIL, there are two special features:***

Reference: https://thomasnyberg.com/releasing_the_gil.html

### 