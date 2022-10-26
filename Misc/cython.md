## Cython Notes

### Releasing GIL
***The GIL is a lock held by the python interpreter process whenever bytecode is being executed unless it is explicitly released. I.e. the design of the cpython interpreter is to assume that whatever that occurs in the cpython process between bytecodes is dangerous and not thread-safe unless told otherwise by the programmer. This means that the lock is enabled by default and that it is periodically released as opposed to the paradigm often seen in many multi-threaded programs where locks are generally not held except when specifically required in so-called "critical sections" (parts of code which are not thread-safe).***

***And when it comes to managing the GIL, there are two special features:***

- The `nogil` function annotation asserts that a Cython function is safe to use without the GIL, and compilation will fail if it interacts with Python in an unsafe manner
- The `with nogil` context manager explicitly unlocks the CPython GIL while active


```python
%%cython

# Annotating a function with `nogil` indicates only that it is safe
# to call in a `with nogil` block. It *does not* release the GIL.
cdef unsigned long fibonacci(unsigned long n) nogil:
    if n <= 1:
        return n

    cdef unsigned long a = 0, b = 1, c = 0

    c = a + b
    for _i in range(2, n):
        a = b
        b = c
        c = a + b

    return c


def cython_nogil(unsigned long n):
    # Explicitly release the GIL while running `fibonacci`
    with nogil:
        value = fibonacci(n)

    return value


def cython_gil(unsigned long n):
    # Because the GIL is not explicitly released, it implicitly
    # remains acquired when running the `fibonacci` function
    return fibonacci(n)
```

> Bottom line: use Cython’s `nogil` annotation to assert that functions are safe for calling when the GIL is unlocked, and `with nogil` to actually unlock the GIL and run those functions

Reference: [Rf1](https://thomasnyberg.com/releasing_the_gil.html), [Rf2](https://speice.io/2019/12/release-the-gil.html)

### 