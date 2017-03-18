# Stackful coroutines for the MSP430

A bare bones coroutine library for the MSP430 microcontroller family.

## Building

Only the small code model and small data model are supported. You will
also need the GNU Binutils installed, namely `msp430-elf-ar` and
`msp430-elf-as`. The implementation assumes an ABI as specified by
slaa534.

Run `make` and copy `coroutine.h` into your project's source tree. Link
your code with `coroutine.a`.

## Documentation

Each coroutine requires at least 18 bytes of stack for its context, if
you want a coroutine with a stack size of 32 bytes you will need to
allocate 50 bytes of memory. Additionally, 16 bytes of the data segment
are needed to save the context of the main coroutine. In a program with
`n` coroutines with a stack size of `s` bytes each, the total memory
usage is `16 + n (18 + s)`.

---

```c
co_stack *co_create(void *stack, size_t stacksize, void (*entry)(void))
```

Creates a new coroutine with a stack size of `stacksize` - 18 bytes. The
context and stack of the newly created coroutine will be saved in the
memory pointed by `stack`, which must be at least 18 bytes long and
2-byte aligned.

When a coroutine is first called, execution starts by invoking its
`entry` function, this function does not take any arguments and must not
return, behaviour is undefined if that ever happens.

Returns a pointer to the coroutine or `NULL` in case of error.

---

```c
co_stack *co_active(void)
```

Returns a pointer to the running coroutine. This function is always
successful.

---

```c
void co_resume(co_stack *coroutine)
```

Starts or continues the execution of `coroutine`. Passing a `NULL` or
invalid coroutine is not allowed. Maskable interrupts are disabled
during a context switch, which will take approximately 63 cycles, or
3.94 us @ 16 MHz.

Calling `co_resume` with the active coroutine as an argument is safe
and execution will continue after `co_resume`, but nothing useful will
be done, you will simply waste cycles.

Calling `co_resume` from inside an ISR is not recommended, you will be
entering here be dragons territory.

---

#### Example

```c
#include "coroutine.h"

static co_stack *co_main;
static co_stack *co_work;
static co_stack stack[(18 + 10) / sizeof(co_stack)];

static void fn(void) {
  while (1) {
    // Produce data.

    co_resume(co_main);
  }
}

int main(void) {
  co_main = co_active();

  if ((co_work = co_create(stack, sizeof(stack), fn)) == NULL) {
    // Handle error.
  }

  for (int i = 0; i < 100; i++) {
    co_resume(co_work);

    // Do something with the data.
  }

  // Rest of the main function.

  return 0;
}
```
