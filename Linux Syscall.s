.intel_syntax noprefix
.global _start
_start:

# For x86_64 using GCC compiler

# Placeholder for demo
SYSCALL_NUM = 0
ARG1 = 1
ARG2 = 2
ARG3 = 3
ARG4 = 4
ARG5 = 5
ARG6 = 6
# ARG7 not valid

# -------------------------------------------------- #
# ------------64bit syscall (x86_64 ABI)------------ #
# -------------------------------------------------- #

# https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/

mov rdi, ARG1
mov rsi, ARG2
mov rdx, ARG3
mov r10, ARG4
mov r8, ARG5
mov r9, ARG6
mov rax, SYSCALL_NUM
syscall
# return value in RAX

# -------------------------------------------------- #
# -------------32bit syscall (i386 ABI)------------- #
# -------------------------------------------------- #

# https://gist.github.com/yamnikov-oleg/454f48c3c45b735631f2#file-syscall_x86_32-md

mov ebx, ARG1
mov ecx, ARG2
mov edx, ARG3
mov esi, ARG4
mov edi, ARG5
mov ebp, ARG6
mov eax, SYSCALL_NUM
int 0x80
# return value in EAX