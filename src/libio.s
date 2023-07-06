.intel_syntax noprefix
.data
.text
.globl printf

# rax -> number of args
# rdi(1st) -> format string
# rsi(2nd) -> arg1
# rdx(3rd) -> arg2
# rcx(4th) -> arg3...
printf:
    # prologue
    push rbp
    mov rbp, rsp

    # seek null charactor and count length
    mov rdx, rdi # seek(rdx) = rdi(1st arg)
    # while (*seek != 0) { seek++;
    .BEGIN_COUNT:
        mov al, BYTE PTR [rdx]
        cmp al, 0
        je .END_COUNT
        add rdx, 1
        jmp .BEGIN_COUNT
    .END_COUNT:    
    #}
    sub rdx, rdi # 3rd: len = seek - &argv[1]
    mov rsi, rdi # 2nd: format string ptr
    mov rdi, 1 # 1st: stdout
    mov rax, 1 # write syscall
    syscall

    # epilogue
    mov rsp, rbp
    pop rbp
    ret


