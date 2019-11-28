; nasm -g -f elf64 euler.asm -o euler.o && gcc -g -c function.c -o function.o && gcc -g -no-pie euler.o function.o -o euler && ./euler

extern printf
extern function

global main

section .data

  x0:     dq 1.0  ; Initial condition x
  t0:     dq 1.0  ; Initial condition t
  step_t: dq 0.1  ; step for time
  
  fmt: db "x(%f) = %f", 10, 0  ; Print format
  n: dd 0                 ; counter
  samples: dd 500         ; samples
  
section .bss

  tn: resq 1
  xn: resq 1
  aux: resq 1
  
section .text

main:

  push rbp ; Push stack
  
  push rax
  push rcx

  mov ecx, dword[samples] ; counter


loop:

  mov dword[n], ecx

  ; calculate t[n] = t[n-1] + dt

  fld qword[tn]
  fadd qword[step_t]
  fstp qword[tn]

  ; calculating x[n] = x[n-1] + dx
  ; where dx = f(t[n])*dt
  
  ; calculating first f(t[n])
  movq xmm0, qword[tn]
  mov rax, 1
  call function
  
  movq qword[aux], xmm0

  ; calculate f(t[n])*dt + x[n-1]
  fld   qword[aux]
  fmul  qword[step_t]
  fadd  qword[xn]
  fstp  qword[xn]
  

  ; print data section
  
  movq xmm0, qword[tn]
  movq xmm1, qword[xn]
  mov rdi, fmt
  mov rax, 2
  call printf


  ; update n
  mov ecx, dword[n]
  dec ecx
  jnz loop


  pop rcx
  pop rax
  
  pop rbp
  ret
