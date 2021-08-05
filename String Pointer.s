.intel_syntax noprefix
.global _start
_start:

# Building C-string using minimal OP code
# For x86_64 using GCC compiler

# -------------------------------------------------- #
# ------------------Build to stack------------------ #
# -------------------------------------------------- #

# Build a string of length 1 ("A") in 2 bytes
push 0x41

# Build a string of length 2 ("AB") in 5 bytes
push 0x4241

# Build a string of length 3 ("ABC") in 5 bytes
push 0x434241

# Build a string of length 4 ("ABCD") in 5 bytes
push 0x44434241

# Build a string of length 5 ("ABCDE") in 10 bytes
push 0x44434241
mov BYTE PTR [rsp + 4], 0x45

# Build a string of length 5 ("ABCDE") in 10 bytes
push 0x41
mov DWORD PTR [rsp + 1], 0x45444342

# Build a string of length 6 ("ABCDEF") in 11 bytes
mov rax, 0x464544434241
push rax

# Build a string of length 6 ("ABCDEF") in 11 bytes
# Causes stack to mis-align by 2 bytes
push 0x46454443
mov ax, 0x4241
push ax

# Build a string of length 7 ("ABCDEFG") in 11 bytes
mov rax, 0x47464544434241
push rax

# Build a string of length 8 ("ABCDEFGH") in 13 bytes
push 0
mov rax, 0x4847464544434241
push rax

# -------------------------------------------------- #

# Extend a string by 8 chars to the front in 11 bytes
mov rax, 0x4847464544434241
push rax

# Get pointer to string in 3 bytes
mov rdi, rsp

# Get pointer to string in 2 bytes
push rsp
pop rdi

# -------------------------------------------------- #
# ------------------Build in .text------------------ #
# -------------------------------------------------- #

# Get pointer to string in 8 bytes
jmp str2
code:
pop rdi
str1:
call code
.asciz "ABCDEFGHIJ"

# Get pointer to string in 7 bytes
lea rdi, [rip + str1]
str2:
.asciz "ABCDEFGHIJ"

# -------------------------------------------------- #

# For length 1 ~ 9: use stack string
# For length 10: use either stack string or LEA
# For length 11 ~ 12: use stack string
# For length 13+: use LEA
