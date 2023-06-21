# CheatSheet
アセンブリでコンパイラを書くときのメモ．

## asm
reference: [Using as - Table of Contents](https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_node/as_toc.html)

### syscall
| Register | Mean |
| --- | --- |
| %rax | syscall number |
| %rdi | 1st arg |
| %rsi | 2nd arg |
| ... | ... |

## ABI
spec: [System V Application Binary Interface AMD64 Architecture Processor Supplement Draft Version 0.99.7](https://uclibc.org/docs/psABI-x86_64.pdf)

rdi -> rsi -> rdx -> rcx -> r8 -> r9

| Register | Usage | Preserved across function calls|
| --- | --- | --- |
| %rax | temporary register; with variable arguments passes information about the number of vector registers used; 1st return register | No |
| %rbx | callee-saved register | Yes |
| %rcx | used to pass 4th integer argument to functions | No |
| %rdx | used to pass 3rd argument to functions; 2nd return register | No |
| %rsp | stack pointer | Yes |
| %rbp | callee-saved register; optionally used as frame pointer | Yes |
| %rsi | used to pass 2nd argument to functions | No |
| %rdi | used to pass 1st argument to functions | No |
| %r8 | used to pass 5th argument to functions | No |
| %r9 | used to pass 6th argument to functions | No |
| %r10 | temporary register, used for passing a function’s static chain pointer | No |
| %r11 | temporary register | No |
| %r12-r14 | callee-saved registers | Yes |
| %r15 | callee-saved register; optionally used as GOT base pointer | Yes |

## C
spec: [ISO/IEC 9899:TC3](https://www.open-std.org/JTC1/SC22/WG14/www/docs/n1256.pdf)
