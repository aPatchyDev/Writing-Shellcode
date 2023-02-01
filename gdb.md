# Using GDB for dynamic analysis

## Compiling for source-level stepthrough

Compile with `-g` option to include debug symbols.  
This allows the debugger to show the source code along with the disassembly while stepping through.

## Setting up GDB

Use pwndbg: [https://github.com/pwndbg/pwndbg](https://github.com/pwndbg/pwndbg)

Also add the following to your `.gdbinit` file to skip library code during debugging:  
`skip -gfi /usr/include/*`

## Frequently used GDB commands

| Command | Alias | Description |
| --- | --- | --- |
| run | r | Begin executing the loaded program |
| start | - | Automatically insert a breakpoint at entry (main function or _start) + run |
| break \[location\] | b \[location\] |  Insert a breakpoint at 'location' |
| continue | c | Continue execution (after hitting a breakpoint) |
| finish | - | Continue execution until the end of this function (break after return) |
| next \<k\> | n \<k\> | Step-over 'k' lines of the program (equivalent to nexti when no debug symbols are present) |
| nexti \<k\> | ni \<k\> | Step-over 'k' assembly instructions of the program |
| step \<k\> | s \<k\> | Step-into 'k' lines of the program (equivalent to stepi when no debug symbols are present) |
| stepi \<k\> | si \<k\> | Step-into 'k' assembly instructions of the program |
| x/\[k\]xb \[location\] | - | View 'k' bytes of data at 'location' as hexadecimal |
| info proc mappings | - | View memory mappings |

Additional reference: [https://sourceware.org/gdb/download/onlinedocs/gdb/Continuing-and-Stepping.html](https://sourceware.org/gdb/download/onlinedocs/gdb/Continuing-and-Stepping.html)

## Specifying location

- Use register value: `$\[reg\]`
    - eg: `x/8xb $rsp` to view 8 bytes of data at the top of the stack
- Use symbol: `*\[symbol\]<+offset>`
    - eg: `b *func+0x20` to insert breakpoint at the function 'func' 0x20 bytes in
- Use pointer dereferencing: `*(\[pointer\])`
    - May need to provide C-style type casting
    - `x/8xb *(void **)($rsp-0x28)` to view 8 bytes of data at the locatoin pointed by `rsp - 0x28`

## Starting up with redirection

1. Launch gdb with file to load  
    eg: `$ gdb a.out`
2. Start with redirection  
    eg: `gdb) start < in.txt`
