.intel_syntax noprefix
.data
    .STRING_STRTOL_ERRMSG: .string "strtol: invalid base(3rd arg)\n"
        LEN_STRTOL_ERRMSG = (. - .STRING_STRTOL_ERRMSG)
.text
.globl strtol
.globl itostr

# rdi(1st) -> const char *restrict nptr
# rsi(2nd) -> char **restrict endptr
# rdx(3rd) -> int base
strtol:
    # prologue
    push rbp
    mov rbp, rsp

    # if (edx != 10) {
        cmp edx, 10
        je .ARGC_IS_10

        # write(2, "invalid arguments\n", 18);
        mov rdx, LEN_STRTOL_ERRMSG # 3rd: len(STRING_STRTOL_ERRMSG)
        lea rsi, .STRING_STRTOL_ERRMSG[rip] # 2nd: string 
        mov edi, 2  # 1st: stderr
        mov eax, 1  # syscall num: write syscall
        syscall

        # return 1;
        mov edi, 1
        mov eax, 0x3c  # syscall num: exit
        syscall

    .ARGC_IS_10:
    #}

    # rax = 0
    mov eax, 0
    # seek null charactor and convert str to long
    mov rdx, rdi # seek(rdx) = rdi(1st arg)
    # while (*seek != 0) { seek++; rax *= 10; rax += str[seek]
    .BEGIN_CONVERT:
        mov bl, BYTE PTR [rdx]
        cmp bl, 0
        je .END_CONVERT
        imul eax, 10
        movzx ebx, bl
        sub ebx, 0x30 # 0x30 = '0'
        add eax, ebx
        add rdx, 1
        jmp .BEGIN_CONVERT
    .END_CONVERT:    
    #}

    # epilogue
    mov rsp, rbp
    pop rbp
    ret

# edi(1st) -> int num
# rax(ret) -> char *str
itostr:
    # prologue
    push rbp
    mov rbp, rsp

    # push num
    push rdi

    # counter(ecx) = 0
    mov ecx, 0

    # while (num < 0) {
    .BEGIN_DIGIT:
        cmp edi, 0
        jl .END_DIGIT
        add ecx, 1
        mov rax, rdi
        mov rbx, 10
        idiv rax, rbx
        mov edi, eax
        jmp .BEGIN_DIGIT
    .END_DIGIT:    
    #}

    # num++ (for null char)
    add ecx, 1

    # malloc(size)
    mov edi, ecx # 1st: size(ecx)
    push rbp
    mov rbp, rsp
    and rsp, -16

    call my_malloc

    mov rsp, rbp
    pop rbp
    push rax
    add rbx, rax
    #=====end func=====

    # pop num
    pop rdi
    movsxd rdi, edi

    # assign null char to end
    mov BYTE PTR[rbx], 0

    # while (rax != rbx) {
    .BEGIN_WRITE_DIGIT:
        cmp rax, rbx
        jl .END_WRITE_DIGIT
        # edi = edi / 10
        # ecx = edi % 10
        cqo
        mov rcx, 10
        mov rax, rdi
        idiv rax, rcx
        mov rdi, rax

        mov BYTE PTR[rbx], cl
        sub rbx, 1
        jmp .BEGIN_WRITE_DIGIT
    .END_WRITE_DIGIT:    
    #}

    # epilogue
    mov rsp, rbp
    pop rbp
    ret
