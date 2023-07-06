.intel_syntax noprefix
.data
    .STRING_INVALID_ARGUMENT: .string "invalid arguments\n"
        LEN_INVALID_ARGUMENT = (. - .STRING_INVALID_ARGUMENT)
    .STRING_PROLOGUE: .string ".intel_syntax noprefix\n.globl main\n"
        LEN_PROLOGUE = (. - .STRING_PROLOGUE - 1)
    .STRING_LABEL_MAIN: .string "main:\n"
        LEN_LABEL_MAIN = (. - .STRING_LABEL_MAIN - 1)
    .STRING_MOV_ARGV1_TO_RAX: .string "\tmov rax, "
        LEN_MOV_ARGV1_TO_RAX = (. - .STRING_MOV_ARGV1_TO_RAX - 1)
    .STRING_LINEBREAK: .string "\n"
        LEN_LINEBREAK = (. - .STRING_LINEBREAK - 1)
    .STRING_RET: .string "\tret\n"
        LEN_RET = (. - .STRING_RET - 1)
.text
.globl main

main:
    # prologue
    push rbp
    mov rbp, rsp
    sub rsp, 0x10   # align16byte(int(4byte) + char*(8byte)) = 0x10(16byte)

    # get argc/argv from arguments
    mov DWORD PTR [rbp - 0x4], edi  # int argc
    mov QWORD PTR [rbp - 0x10], rsi # char **argv

    # if (argc != 2) {
        cmp edi, 2
        je .ARGC_IS_2

        # write(2, "invalid arguments\n", 18);
        mov rdx, LEN_INVALID_ARGUMENT # 3rd: len("invalid arguments\n")
        lea rsi, .STRING_INVALID_ARGUMENT[rip] # 2nd: string 
        mov rdi, 2  # stderr
        mov rax, 1  # syscall num: write syscall
        syscall

        # return 1;
        mov rax, 1
        mov rsp, rbp
        pop rbp
        ret

    .ARGC_IS_2:
    #}

    # write(1, ".intel_syntax noprefix\n.globl main\n", 35);
    mov rdx, LEN_PROLOGUE # 3rd: len(".intel_syntax noprefix\n.globl main\n")
    lea rsi, .STRING_PROLOGUE[rip] # 2nd: string 
    mov rdi, 1  # 1st: stdout
    mov rax, 1  # syscall num: write syscall
    syscall

    # write(1, "main:\n", 6);
    mov rdx, LEN_LABEL_MAIN  # 3rd: len("main:\n")
    lea rsi, .STRING_LABEL_MAIN[rip] # 2nd: string 
    mov rdi, 1  # 1st: stdout
    mov rax, 1  # syscall num: write syscall
    syscall

    # write(1, "\tmov rax, ", 11);
    mov rdx, LEN_MOV_ARGV1_TO_RAX # 3rd: len("\tmov rax, ")
    lea rsi, .STRING_MOV_ARGV1_TO_RAX[rip] # 2nd: string 
    mov rdi, 1  # 1st: stdout
    mov rax, 1  # syscall num: write syscall
    syscall

    # write(1, argv[1], 2);
    mov rsi, [rbp - 0x10] # char **argv 
    mov rsi, [rsi] # char *argv
    add rsi, 8  # argv + 1
    # seek null charactor and count length
    mov rdx, rsi
    # while (*seek != 0) { seek++;
    .BEGIN_COUNT:
        mov al, BYTE PTR [rdx]
        cmp al, 0
        je .END_COUNT
        add rdx, 1
        jmp .BEGIN_COUNT
    .END_COUNT:    
    #}

    sub rdx, rsi    # 3rd: len = seek - &argv[1]
    mov rdi, 1  # 1st: stdout
    mov rax, 1  # syscall num: write syscall
    syscall

    # write(1, "\n", 1);
    mov rdx, LEN_LINEBREAK # 3rd: len("\n")
    lea rsi, .STRING_LINEBREAK[rip] # 2nd: string 
    mov rdi, 1  # 1st: stdout
    mov rax, 1  # syscall num: write syscall
    syscall

    # write(1, "\tret\n", 5);
    mov rdx, LEN_RET # 3rd: len("\tret\n")
    lea rsi, .STRING_RET[rip] # 2nd: string 
    mov rdi, 1  # 1st: stdout
    mov rax, 1  # syscall num: write syscall
    syscall

    # return 0;
    mov rax, 0

    # epilogue
    mov rsp, rbp
    pop rbp
    ret
