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
jmp str1
code1:
pop rdi
# <continue execution here>
str1:
call code1
.asciz "ABCDEFGHIJ"

# Get pointer to string in 7 bytes
lea rdi, [rip + str2]
# <continue execution here>
str2:
.asciz "ABCDEFGHIJ"

# Get pointer to string in 6 bytes
# Must embed string directly at the position it is required
call code2
.asciz "ABCDEFGHIJ"
code2:
pop rdi
# <continue execution here>

# -------------------------------------------------- #
# --------------------Conclusion-------------------- #
# -------------------------------------------------- #

# For length 1 ~ 4: use stack string
# For length 5 ~ 6: use either stack string or in-place call
# For length 7: use stack string
# For length 8: use either stack string or in-place call
# For length 9: use stack string
# For length 10: use in-place call
# For length 11: use either stack string or in-place call
# For length 12: use stack string
# For length 13+: use in-place call

# Byte count formula for C-string of length n
# stack string = floor((n-1) / 8) * 11 + [4, 7, 7, 7, 12, 13, 13, 15][(n-1) mod 8] (0-indexed list)
# in-place call = n + 7
# lea = n + 8
# jmp call = n + 9