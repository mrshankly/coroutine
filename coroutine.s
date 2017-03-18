.data
  .balign 2 { .type co_current, @object
co_current:
  .refsym co_main
  .local  co_main
  .comm   co_main, 16, 2

.text
  .balign 2 { .global co_create { .type co_create, @function
co_create:
  mov r12, r15
  bis r13, r15
  bis r14, r15
  bit  #1, r15
  jnz .err

  cmp #18, r13
  jlo .err

  add  r12, r13
  decd r13
  mov  r14, 0(r13)
  mov  r13, 0(r12)
  ret
.err:
  clr r12
  ret

  .balign 2 { .global co_active { .type co_active, @function
co_active:
  mov &co_current, r12
  ret

  .balign 2 { .global co_resume { .type co_resume, @function
co_resume:
  mov r2, r13
  dint
  nop

  mov &co_current, r14
  mov r12, &co_current

  mov r1 ,  0(r14)
  mov r4 ,  2(r14)
  mov r5 ,  4(r14)
  mov r6 ,  6(r14)
  mov r7 ,  8(r14)
  mov r8 , 10(r14)
  mov r9 , 12(r14)
  mov r10, 14(r14)

  mov @r12+, r1
  mov @r12+, r4
  mov @r12+, r5
  mov @r12+, r6
  mov @r12+, r7
  mov @r12+, r8
  mov @r12+, r9
  mov @r12 , r10

  mov r13, r2
  ret
