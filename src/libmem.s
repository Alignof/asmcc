.intel_syntax noprefix
.data
    .STRING_MALLOC_ERRMSG: .string "malloc size error\n"
        LEN_MALLOC_ERRMSG = (. - .STRING_MALLOC_ERRMSG)
    malloc_head:
        .zero 8
    malloc_size:
        .zero 8
.text
.globl my_malloc

# edi(1st) -> int size
# static: void *malloc_head
# static: size_t malloc_size
my_malloc:
    # prologue
    push rbp
    mov rbp, rsp
    sub rsp, 0x10

    mov DWORD PTR [rbp - 0x4], edi # int size

    # if (head == NULL) {
        mov rax, QWORD PTR malloc_head[rip]
        cmp rax, 0
        je .MALLOC_HEAD_IS_NOT_NULL

        # brk(0)
        mov rdi, 0
        mov eax, 12  # syscall num: brk
        syscall

        # *malloc_head = brk(0)
        mov rdi, rax
        add rdi, 0x10000000
        mov eax, 12  # syscall num: brk
        syscall
        mov rbx, QWORD PTR malloc_head[rip]
        mov DWORD PTR [rbx], eax

        # malloc_size = 0x10000000
        mov QWORD PTR malloc_size[rip], 0x10000000
    .MALLOC_HEAD_IS_NOT_NULL:
    #}

    # if (malloc_size < size) {
        lea rax, QWORD PTR malloc_size[rip]
        mov ebx, DWORD PTR [rbp - 0x4]
        movsxd rbx, ebx
        cmp rax, rbx
        jl .MALLOC_SIZE_OK

        # write(2, "malloc size error\n", len(MALLOC_ERRMSG));
        mov rdx, .STRING_MALLOC_ERRMSG # 3rd: len(MALLOC_ERRMSG)
        lea rsi, .STRING_MALLOC_ERRMSG[rip] # 2nd: string 
        mov edi, 2  # 1st: stderr
        mov eax, 1  # syscall num: write syscall
        syscall

        # return 1;
        mov edi, 1
        mov eax, 0x3c  # syscall num: exit
        syscall
    .MALLOC_SIZE_OK:
    #}

    # rax = malloc_head
    mov rax, QWORD PTR malloc_head[rip]

    # malloc_head += size
    mov ebx, DWORD PTR [rbp - 0x4]
    movsxd rbx, ebx
    add QWORD PTR malloc_head[rip], rbx

    # malloc_size -= size
    sub QWORD PTR malloc_size[rip], rbx

    # epilogue
    mov rsp, rbp
    pop rbp
    ret
