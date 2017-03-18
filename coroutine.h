#ifndef COROUTINE_H
#define COROUTINE_H

#include <stddef.h>

typedef unsigned int co_stack;

extern co_stack *co_create(void *, size_t, void (*)(void));
extern co_stack *co_active(void);
extern void co_resume(co_stack *);

_Static_assert(sizeof(void (*)(void)) == 2, "small code model not enabled");
_Static_assert(sizeof(void *)         == 2, "small data model not enabled");

#endif
